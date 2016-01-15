URL = require('url');
getAlternateAvatar = require("./findAlternateAvatar.coffee")
he = require('he')
truncate = require('truncate')
urlify = require('urlify').create
	addEToUmlauts:true,
	szToSs:true,
	spaces:"-",
	nonPrintable:"-",
	trim:true

# when the other seite responds with rss,
# do something with the data
module.exports = onFollowerRssResponse = (err, response, domain, db)->
	return false if err

	# check if we can get a domain out of the first
	# post item of the rss feed. sometimes the feed domain
	# isnt the autor domain (like feedburner urls)
	if response.items.length > 0 && response.items[0].guid
		# first post item contains a post link
		# use this as domain
		if response.items[0].guid.link
			domain = response.items[0].guid.link
		else if  response.items[0].url
			domain = response.items[0].url
		else
			# keep the address of the feed
			# as a domain. hopefully it isnt
			# feedburner
			domain = domain

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

				created = row.published_at
				created = Date.now() if isNaN(created)

				# create a new doc to insert
				newDoc = {}
				newDoc.type = "rss_post"
				newDoc.title = ""
				newDoc.content = ""
				newDoc.created = created
				newDoc._id = created+'-'+urlify(title)+'-'+cleanDomain
				newDoc.check = urlify(title)+'-'+cleanDomain
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
				if isNaN(row.published_at) == false && db
					# look for existing doc in db
					db.get(newDoc._id).then (otherDoc)->
							return true
							#console.log db.remove(otherDoc._id, otherDoc._rev)
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
				else if db
					# try to get the date out of the db
					# maybe the post is already in the db
					# and we assigned a new date a first scrape
					db.query("get_checks", {
							key: newDoc.check,
							include_docs: true
						})
						.then (otherDoc) ->
							if otherDoc.rows.length == 0
								# create a new entry (no _rev)
								db.put(newDoc).catch (err)-> console.log err
						.catch (err) ->
							if err.status == 404
								# create a new entry (no _rev)
								db.put(newDoc).catch (err)-> console.log err

				else
					console.log "no db!"
