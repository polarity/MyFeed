request = require('request')
db = false

# when the other myfeed api responds,
# do something with the data
onFollowerResonse = (error, response, html, domain)->

	# clean the received domain string
	cleanDomain = domain
					.replace('http://','')
					.replace('https://','')
					.replace('www.', '')
					.replace(/\-/g, '_')
					.replace(/\./g, '_')
					.replace(/\//g, '_')

	if response.statusCode == 200

		receivedData = JSON.parse(response.body)

		# iterate over all docs in the api response
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

				# use the old revision hash
				newDoc._rev = otherDoc._rev

				# update existing entry
				db.put(newDoc).catch (err)-> console.log err

			# catch when theres no doc in the db
			.catch (err)->
				# es gibt wohl noch kein dokument
				console.log "Kein Dokument da. Also insert! "+err

				# create a new entry (no _rev)
				db.put(newDoc)
				# doc saved?
				.then (response)-> console.log response
				.catch (err)-> console.log err

# when the pouchdb responds with an array
# of followed myfeeds
onDbResponse = (err, docs)->
	if docs
		docs.rows.forEach (row)->
			request.post row.doc.domain+'/api/feed', (error, response, html)->
					onFollowerResonse(error, response, html, row.doc.domain)

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