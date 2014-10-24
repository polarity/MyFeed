urlify = require('urlify').create
	addEToUmlauts:true,
	szToSs:true,
	spaces:"-",
	nonPrintable:"-",
	trim:true

# database migration? 
# change keys to current
module.exports = (docs)->
	# change db keys if wrong
	docs.rows.forEach (doc)->
		# create new doc
		newDoc = {}
		newDoc.title = generateTitleFromPost(doc.doc)
		newDoc._id = doc.doc.created+'-'+urlify(newDoc.title)
		newDoc.created = doc.doc.created
		newDoc.content = doc.doc.content
		newDoc.attachments = doc.doc.attachments
		newDoc.type = doc.doc.type
		newDoc.user = doc.doc.user

		# delete old doc
		pdb.remove(doc.doc._id, doc.doc._rev)
			.then (res)->
				# save new doc!
				pdb.put(newDoc)
					.then (res)->
						# console.log "Success Save New Doc: ",newDoc
						return
					.catch (err)->
						console.log "Fehler Save New Doc: ",err

			.catch (err)->
				console.log "Fehler Delete Old Doc: ",err