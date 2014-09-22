Express = require "express"
md5 = require "md5"
dotenv = require "dotenv"
markdown = require("node-markdown").Markdown
stylus = require 'stylus'
bodyParser = require 'body-parser'
myFeedScrape = require 'myfeed-scrape'
jwt = require('jwt-simple')
secret = '9w384uwioejrkkweroo9i9o'
livereload = require('express-livereload')
PouchDB = require('pouchdb')

# passport authenticate
passport = require('passport')
LocalStrategy = require('passport-local').Strategy
TokenStrategy = require('passport-token-auth').Strategy

# init
# dotenv.load()
dotenv._getKeysAndValuesFromEnvFilePath(__dirname + '/.env')
dotenv._setEnvs();

app = Express()

# use live reload on the developer env
if process.env.USE == "DEVELOPMENT"
	livereload(app, {watchDir: __dirname+'/stylus'})

# database
pdb = new PouchDB(__dirname + '/_pouchdb')

# middleware
app.set 'view engine', 'jade'
app.use stylus.middleware({src: __dirname + '/stylus', dest: __dirname + '/css'})
app.use '/css', Express.static(__dirname + '/css')
app.use '/js', Express.static(__dirname + '/js')
app.set 'views', __dirname + '/views'
app.use bodyParser.json()
app.use passport.initialize()
app.use passport.session()

# admin user 
user = {}
user.id = "myid"
user.email = process.env.USER_EMAIL
user.emailhash = md5.digest_s(user.email)
user.password = process.env.USER_PASSWORD
user.username = process.env.USER_NAME

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
localStrategy = new LocalStrategy (username, password, done)->
	
	# wrong password?
	if user.password != password
		return done null, false, { message: 'Incorrect password.' }
	else
		# log in, send token back
		return done(null, user)

# define the app auth strategy
tokenStrategy = new TokenStrategy (token, done)->
	# wrong password?
	decodedToken = jwt.decode(token, secret)

	if user.password != decodedToken.password
		return done null, false, { message: 'Incorrect token, sorry!' }
	else
		# log in, send token back
		return done(null, user)

# use the app strategy
passport.use(localStrategy)
passport.use(tokenStrategy)

sortByDate = (a,b)->
	return (new Date(a.doc.created).getTime()) - (new Date(b.doc.created).getTime())

# database migration? 
# change keys to current
correctDocKeys = (docs)->
	# change db keys if wrong
	docs.rows.forEach (doc)->
		if doc.doc.attachments
			doc.doc.attachments.forEach (att)->
				if att.excerpt
					att.description = att.excerpt
					delete att.excerpt
				if att.thumb
					att.thumbnail = att.thumb
					delete att.thumb

			console.log '\n\n'
			console.log '-----------'
			console.log doc.doc
			pdb.put(doc.doc)

# routes
#

# get the feed overview
app.get "/", (req, res)->
	pdb.allDocs {include_docs: true}, (err, docs)->
		if docs
			res.render("feed", {
				rows: docs.rows.sort(sortByDate).reverse()
				user: user
				markdown: markdown
				environment: process.env.USE
			})

# get the feed overview
app.get "/login", (req, res)->
	res.render("login", {
		user: user
		domain: process.env.DOMAIN_URL
		markdown: markdown
		environment: process.env.USE
	})

# get the feed via json api
app.get "/api/feed", (req, res)->
	pdb.allDocs {include_docs: true}, (err, docs)->
		if docs
			#correctDocKeys(docs)

			res.setHeader 'Content-Type', 'application/json'
			res.end JSON.stringify {
				rows: docs.rows.sort(sortByDate).reverse()
				user: user
				markdown: markdown
			}

# post a new post
app.post "/api/create", passport.authenticate('token', { session: false }), (req, res)->
	doc = {}
	doc = req.body.doc
	doc.user = {
		email: user.email
		emailhash: user.emailhash
		username: user.username
	}
	pdb.post(doc).then (response)->
		# doc saved?
		res.json(response)

# post a new post
app.post "/api/delete", passport.authenticate('token', { session: false }), (req, res)->
	console.log req.body.id
	pdb.remove(req.body._id, req.body._rev)
	.then (response)->
		# doc deleted?
		res.end("true")
	.catch (err)->
		console.log err

# login!
app.post '/api/login', passport.authenticate('local', { session: false }), (req, res) ->
	# send token back!
	res.json({
		user: {
			email: user.email
			emailhash: user.emailhash
			username: user.username
		},
		token: jwt.encode({
			username: req.user.username, 
			password: req.user.password
		}, 
		secret)
	})

# scrape a website url
app.post "/api/scrapethis", passport.authenticate('token', { session: false }), (req, res)->
	myFeedScrape.scrape(req, res)

server = app.listen process.env.SERVERPORT, ()->
	console.log "Listening....", server.address().port
