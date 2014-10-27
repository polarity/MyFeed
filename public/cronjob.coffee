request = require('request')
db = false

# when the other myfeed api responds,
# do something with the data
onFollowerResponse = (error, response, html, domain)->

	# exit if theres no 200er response
	return false if response.statusCode != 200

	# clean the received domain string
	cleanDomain = domain
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
					.then (response)-> console.log response
					.catch (err)-> console.log err

# when the pouchdb responds with an array
# of followed myfeeds
onDbResponse = (err, docs)->
	return false if !docs
	docs.rows.forEach (row)->
		request.post row.doc.domain+'/api/feed', (error, response, html)->
				onFollowerResponse(error, response, html, row.doc.domain)

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