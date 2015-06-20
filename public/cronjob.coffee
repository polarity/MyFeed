URL = require('url');
request = require('request')
feedparser = require('rssparser')
urlify = require('urlify').create
	addEToUmlauts:true,
	szToSs:true,
	spaces:"-",
	nonPrintable:"-",
	trim:true

db = false

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
		newDoc._id = row.doc._id+'-'+cleanDomain
		delete newDoc._rev # remove this key

		# check received domain strings
		if newDoc.user.domain && newDoc.user.domain.slice(-1) == '/'
			# remove trailing slash if exists
			newDoc.user.domain = newDoc.user.domain.slice(0,-1)

		# look for existing doc in db
		db.get(newDoc._id).then (otherDoc)->
				return true
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

	# clean the received domain string
	cleanDomain = URL.parse(domain).hostname
		.replace('http://','')
		.replace('https://','')
		.replace('www.', '')
		.replace(/\-/g, '_')
		.replace(/\./g, '_')
		.replace(/\//g, '_')

	# each item
	response.items.forEach (row)->
		# create a new doc to insert
		newDoc = {}
		newDoc.type = "rss_post"
		newDoc.title = ""
		newDoc.content = ""
		newDoc.created = row.published_at
		newDoc._id = row.published_at+'-'+urlify(row.title)+'-'+cleanDomain
		newDoc.user = {
			username: row.author
			email: ""
			emailhash: ""
			domain: URL.parse(domain).hostname
		}
		newDoc.attachments = [
			{
				title: row.title
				# strip html tags
				description: row.summary.replace(/<(?:.|\n)*?>|[\n\r]/gm, '')
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
					#db.remove(otherDoc._id, otherDoc._rev)
					#
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


# when the pouchdb responds with an array
# of followed myfeeds
onDbResponse = (err, docs)->
	return false if !docs
	docs.rows.forEach (row)->
		# parse myfeed
		request.post row.doc.domain+'/api/feed', (error, response, html)->
			# is myfeed? post should give 200 and app/json header
			if response.statusCode == 200 && response.headers['content-type']=='application/json'
				# parse myfeed
				onFollowerResponse(error, response, html, row.doc.domain) if !error 
			else
				# try get instead / without api path
				request.get row.doc.domain, (error, response, html)->
					# should be rss: text/xml
					# and give a 200
					if response.statusCode == 200 && /text\/xml/.test(response.headers['content-type'])
						feedparser.parseURL row.doc.domain, {}, (err, response)->
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