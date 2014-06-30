Express = require "express"
CouchDB = require "couchdb-api"
md5 = require "md5"
dotenv = require "dotenv"
markdown = require("node-markdown").Markdown

# init
dotenv.load()
app = Express()
app.set 'view engine', 'jade'
app.use '/css', Express.static(__dirname + '/css')
app.use '/js', Express.static(__dirname + '/js')

# db
dbServer = CouchDB.srv(process.env.COUCHDB_URL)
dbServer.auth = [
	process.env.COUCHDB_USER
	process.env.COUCHDB_PW
]
db = dbServer.db('items')

user = {}
user.email = process.env.USER_EMAIL
user.emailhash = md5.digest_s(user.email)

sortByDate = (a,b)->
	return (new Date(a.doc.created).getTime()) - (new Date(b.doc.created).getTime())

# routes
app.get "/feed", (req, res)->
	db.allDocs {include_docs: true}, (err, docs)->
		if docs
			res.render("feed", {
				rows: docs.rows.sort(sortByDate).reverse(), 
				user: user,
				markdown: markdown
			})

server = app.listen 8000, ()->
	console.log "Listening....", server.address().port
