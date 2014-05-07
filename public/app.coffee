Express = require "express"
CouchDB = require "couchdb-api"

# init
app = Express()
app.set 'view engine', 'jade'

# db
dbServer = CouchDB.srv("https://robse.iriscouch.com")
dbServer.auth = "polarity:A3Cwzd5asFCmLSkMmSTXcdB"
db = dbServer.db('items')

#test = db.doc({"name": "marie", "nachname":"schweiz"})
#test.save()

# routes
app.get "/feed", (req, res)->
	db.allDocs {include_docs: true}, (err,docs)->
		res.render("feed", {docs: docs.rows})


server = app.listen 8000, ()->
	console.log "Listening....", server.address().port