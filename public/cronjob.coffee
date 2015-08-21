URL = require('url');
request = require('request')
feedparser = require('rssparser')
cheerio = require('cheerio');
urlify = require('urlify').create
	addEToUmlauts:true,
	szToSs:true,
	spaces:"-",
	nonPrintable:"-",
	trim:true
he = require('he')
truncate = require('truncate')
db = false

# takes the a thumb "url of og:image" tag and the
# "url of the html document" and convert the thumb
# urls to correct absolute urls
# 
# "//domain.tld/path/img.gif" -> "http://domain.tld/path/img.gif"
# "/path/img.gif" -> "http://domain.tld/path/img.gif"
# "img.gif" -> "http://domain.tld/path/img.gif"
thumbnailUrlConvert = (thumbnailUrl, posturl)->

	# thumbnail exists?
	if thumbnailUrl

		if thumbnailUrl.substr(0,1) == "/" && thumbnailUrl.substr(1,1) != "/"
			# thumb on the same domain
			# thumb relative url from root
			# lacking protocol + domain
			# -> "/path/absolute/thumb.gif"
			# prepend domain to make it work
			urlObj = URL.parse(posturl)
			thumbnailUrl = urlObj.protocol+"//"+urlObj.hostname+thumbnailUrl

		else if thumbnailUrl.substr(0,1) != "/" && thumbnailUrl.substr(0,4) != "http"
			# thumb on the same domain
			# thumb relative to document linked
			# lacking protocol + domain + root slash
			# -> "path/relative/thumb.gif"
			# prepend domain and document path
			urlObj = URL.parse(posturl)
			thumbnailUrl =  urlObj.protocol+"//"+urlObj.hostname+'/'+thumbnailUrl

		else if thumbnailUrl.substr(0,2) == "//"
			# thumb on another domain, url lacking protocol
			# lacking protocol
			# -> "//domain/path/thumb.gif"
			thumbnailUrl =  "http:"+thumbnailUrl

	return thumbnailUrl

getParams = (str) ->
	params = str.split(';').reduce(((params, param) ->
		parts = param.split('=').map((part) ->
			part.trim()
		)
		if parts.length == 2
		  params[parts[0]] = parts[1]
		params
	), {})
	params

# try to get an Avatar or thumbnail for a
# website. favicon, logo.png or some random
# image from the page. we need this for
# a nice interface 
getAlternateAvatar = (hostname,  callback)->
	request.get "http://"+hostname+"/favicon.ico", (error, response, html)->
		# should deliver an 200 and shouldnt be 0 bytes
		# some webserver (microsoft) deliver 200 AND an ico with 0 bytes
		if !error && response.statusCode == 200 && response.headers['content-length'] != "0"
			callback("http://"+hostname+"/favicon.ico") 
		else
			# try to get ANY image from the index webpage 
			# of the feed
			request.get  "http://"+hostname, (error, response, html)->
				if !error
					# where trying to get different images
					# from the webpage
					thumbnail = undefined

					# get all image tags from the webpage
					$ = cheerio.load(html)
					images = $("img")

					# images is array?
					if images.length > 0
						# step each image
						images.each (index, img)->
							# try to sneak logo :)
							if /logo/.test($(img).attr("src"))
								thumbnail = $(img).attr("src")

					# still no image? get ANY img you find
					if !thumbnail
						thumbnail = $("img").attr("src")

					# convert url
					if(thumbnail)
						thumbnail = thumbnailUrlConvert(thumbnail, "http://"+hostname)

					# return
					callback(thumbnail)

# when the other myfeed api responds,
# do something with the data
onFollowerResponse = (error, response, html, domain)->

	# exit if theres no 200er response
	return false if response.statusCode != 200

	# clean the received domain string
	cleanDomain = URL.parse(domain).hostname
		.replace('http://','')
		.replace('https://','')
		.replace('www.', '')
		.replace(/\-/g, '_')
		.replace(/\./g, '_')
		.replace(/\//g, '_')

	# iterate over all docs in the api response
	receivedData = JSON.parse(response.body)
	receivedData.rows.forEach (row)->

		# create a new doc to insert
		newDoc = {}
		newDoc = row.doc
		newDoc.type = "foreign_post"
		newDoc._id = row.doc._id+'#'+cleanDomain
		delete newDoc._rev # remove this key

		# check received domain strings
		if newDoc.user.domain && newDoc.user.domain.slice(-1) == '/'
			# remove trailing slash if exists
			newDoc.user.domain = newDoc.user.domain.slice(0,-1)

		# look for existing doc in db
		db.get(newDoc._id).then (otherDoc)->
				return true
				#db.remove(otherDoc._id, otherDoc._rev)
				# current: dont update existing docs
				# it creates only new revisions and clutters
				# the db. only insert new docs

				# use the old revision hash
				# newDoc._rev = otherDoc._rev

				# update existing entry
				# db.put(newDoc).catch (err)-> console.log err

			# catch when theres no doc in the db
			.catch (err)->
				# create a new entry (no _rev)
				db.put(newDoc)
					# doc saved?
					.catch (err)-> console.log err

onFollowerRssResponse = (err, response, domain)->
	return false if err
	# check if we can get a domain out of the first 
	# post item of the rss feed. sometimes the feed domain
	# isnt the autor domain (like feedburner urls)
	if response.items[0].guid && response.items[0].guid.link
		# first post item contains a post link
		# use this as domain
		domain = response.items[0].guid.link

	# extract the hostname
	hostname = URL.parse(domain).hostname

	if hostname
		# clean the received domain string
		# just leave the hostname. get
		# rid of special chars. we use the
		# hostname as part of the doc._id
		cleanDomain = hostname
			.replace('http://','')
			.replace('https://','')
			.replace('www.', '')
			.replace(/\-/g, '_')
			.replace(/\./g, '_')
			.replace(/\//g, '_')

		# each post rss item
		response.items.forEach (row)->

			# try to get an image for the website
			# rss dont contains a favicon nor thumbnail nor logo
			# so try to get one. avatarUrl is empty on fail
			getAlternateAvatar URL.parse(domain).hostname,(avatarUrl)->

				# get title of this post
				title = row.title || "Kein Titel"

				# get author name
				# when no author given, use <title> of the feed channel
				author = row.author || response.title || "Kein Name vergeben"

				# get and edit excerpt
				summary = ""
				if row.summary && typeof row.summary == "string"
					summary = row.summary
						.replace(/<(?:.|\n)*?>|[\n\r]/gm, '') # strip html tags
						.replace('&#8230;', '...') # replace sgml stuff
					summary = he.decode(summary)
					summary = truncate(summary, 350)

				# get website / domain of the blog
				# 
				# use the feed url to parse the root url!
				# sometimes its just feed.feedburner.com :(
				# so not very good, but be have something to
				# work with
				website = URL.parse(domain).hostname 

				# when possible, use the article permanent url
				# to get root url. better because the article 
				# should be on the original website not on the
				# feedproxy
				website = URL.parse(row.url).hostname if row.url

				# create a new doc to insert
				newDoc = {}
				newDoc.type = "rss_post"
				newDoc.title = ""
				newDoc.content = ""
				newDoc.created = row.published_at
				newDoc._id = row.published_at+'-'+urlify(title)+'-'+cleanDomain
				newDoc.user = {
					username: author
					email: ""
					emailhash: ""
					domain: website
					thumbnail: avatarUrl
				}

				# make the post an attachment 
				newDoc.attachments = [
					{
						title: row.title
						description: summary
						type: "url"
						url: row.url
					}
				]
				# add only docs with correct pubDate
				# somtetimes rss feeds have
				# wrong date formats

				if isNaN(row.published_at) == false
					# look for existing doc in db
					db.get(newDoc._id).then (otherDoc)->						
							return true
							#console.log db.remove(otherDoc._id, otherDoc._rev)

							#
							# current: dont update existing docs
							# it creates only new revisions and clutters
							# the db. only insert new docs

							# use the old revision hash
							#newDoc._rev = otherDoc._rev

							# update existing entry
							#db.put(newDoc).catch (err)-> console.log err

						# catch when theres no doc in the db
						.catch (err)->
							# create a new entry (no _rev)
							db.put(newDoc)
								# doc saved?
								.catch (err)-> console.log err

# when the pouchdb responds with an array
# of followed myfeeds
onDbResponse = (err, docs)->
	return false if !docs
	docs.rows.forEach (row)->
		# parse myfeed
		request.post row.doc.domain+'/api/feed', (error, response, html)->
			# is myfeed? post should give 200 and app/json header
			if !error && response.statusCode == 200 && response.headers['content-type']=='application/json'
				# parse myfeed
				onFollowerResponse(error, response, html, row.doc.domain) if !error 
			else
				# try get instead / without api path
				request.get row.doc.domain, (error, response, html)->
					# should be rss: text/xml ~ application/xml
					# and give a 200
					if !error && response.statusCode == 200 && (/text\/xml/.test(response.headers['content-type']) || /application\/xml/.test(response.headers['content-type']))
						charset = getParams(response.headers['content-type'] || '').charset || "UTF-8"
						feedparser.parseURL row.doc.domain, {rssEncoding: charset}, (err, response)->
							onFollowerRssResponse(err, response, row.doc.domain)

# called every nth time
# as long the app runs
onInterval = ()->
	map = (doc, emit)=> emit(doc._id, doc) if doc.type == 'follow'
	db.query map, {include_docs: true}, onDbResponse

# export to use this in our main app
module.exports = (pdb, delay)->
	db = pdb
	setInterval onInterval, delay
	onInterval()