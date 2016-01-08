URL = require('url');

# when the other myfeed api responds,
# do something with the data
module.exports = onFollowerResponse = (error, response, html, domain, db)->

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
