Express = require "express"
CouchDB = require "couchdb-api"
md5 = require "md5"
dotenv = require "dotenv"
markdown = require("node-markdown").Markdown
stylus = require 'stylus'
bodyParser = require 'body-parser'
myFeedScrape = require 'myfeed-scrape'

# passport authenticate
passport = require('passport')
LocalStrategy = require('passport-local').Strategy

# init
dotenv.load()
app = Express()
app.set 'view engine', 'jade'

app.use stylus.middleware({src: __dirname + '/stylus', dest: __dirname + '/css'})
app.use '/css', Express.static(__dirname + '/css')
app.use '/js', Express.static(__dirname + '/js')
app.use bodyParser.json()
app.use passport.initialize()
app.use passport.session()

# db
dbServer = CouchDB.srv(process.env.COUCHDB_URL)
dbServer.auth = [
	process.env.COUCHDB_USER
	process.env.COUCHDB_PW
]
db = dbServer.db('items')

user = {}
user.id = "mamamamamamama"
user.email = process.env.USER_EMAIL
user.emailhash = md5.digest_s(user.email)
user.password ="hastenichgesehn"

# Passport session setup.
# To support persistent login sessions, Passport needs to be able to
# serialize users into and deserialize users out of the session.  Typically,
# this will be as simple as storing the user ID when serializing, and finding
# the user by ID when deserializing.
passport.serializeUser (user, done)->
	done(null, user.id)

passport.deserializeUser (id, done)->
	done(err, user)

# define the app auth strategy
appStrategy = new LocalStrategy (username, password, done)->
	
	# wrong password?
	if user.password != password
		return done null, false, { message: 'Incorrect password.' }
	else
		# log in 
		return done(null, user);

# use the app strategy
passport.use(appStrategy)

sortByDate = (a,b)->
	return (new Date(a.doc.created).getTime()) - (new Date(b.doc.created).getTime())

# routes
#

# get one specific blog post
app.get "/post/:id", (req, res)->
	db.allDocs {include_docs: true}, [req.params.id], (err, docs)->
		if docs
			res.render("feed", {
				rows: docs.rows.sort(sortByDate).reverse(), 
				user: user,
				markdown: markdown
			})

# get the feed overview
app.get "/admin/feed", (req, res)->
	db.allDocs {include_docs: true}, (err, docs)->
		if docs
			res.render("admin-feed", {
				rows: docs.rows.sort(sortByDate).reverse(), 
				user: user,
				markdown: markdown
			})


# get the feed via json api
app.get "/api/feed", (req, res)->
	db.allDocs {include_docs: true}, (err, docs)->
		if docs
			res.setHeader 'Content-Type', 'application/json'
			res.end JSON.stringify {
				rows: docs.rows.sort(sortByDate).reverse(), 
				user: user,
				markdown: markdown
			}

# post a new post
app.post "/api/create", (req, res)->
	doc = db.doc()
	doc.body = req.body
	doc.save (doc)->
		# doc saved?
		res.end("true")

# login!
app.post '/api/login', passport.authenticate('local', {}), (req, res) ->
	if req.isAuthenticated() 
		res.end("logged in!")
	else
		res.end("NOT logged in!")


# scrape a website url
app.post "/api/scrapethis", (req, res)->
	myFeedScrape.scrape(req, res)

server = app.listen 8000, ()->
	console.log "Listening....", server.address().port
