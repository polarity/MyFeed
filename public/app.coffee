# node modules
Express = require "express"
md5 = require "md5"
dotenv = require "dotenv"
markdown = require("node-markdown").Markdown
stylus = require 'stylus'
bodyParser = require 'body-parser'
myFeedScrape = require 'myfeed-scrape'
jwt = require('jwt-simple')
livereload = require('express-livereload')
truncate = require('truncate')
PouchDB = require('pouchdb')
RSS = require('rss')
Promise = require('bluebird')
urlify = require('urlify').create
	addEToUmlauts:true,
	szToSs:true,
	spaces:"-",
	nonPrintable:"-",
	trim:true

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
app.use '/js', Express.static(__dirname + '/_js')
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
user.domain = process.env.DOMAIN_URL

# generate settings document
pdb.get("settings").catch (err)->
	doc = {}
	doc._id = "settings"
	doc.type = "settings"
	pdb.put(doc).catch (err)-> console.log('cant create settings doc ...')

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
	decodedToken = jwt.decode(token, process.env.SECRET)

	if user.password != decodedToken.password
		return done null, false, { message: 'Incorrect token, sorry!' }
	else
		# log in, send token back
		return done(null, user)

# use the app strategy
passport.use(localStrategy)
passport.use(tokenStrategy)

# app modules
generateTitleFromPost = require('./helper_generate-title-from-post.coffee')
correctDocKeys = require('./helper_correct-doc-keys.coffee')

# every 10 minutes
require('./cronjob.coffee')(pdb, (10 * 60000))

# routes
#

# get the feed overview
app.get "/", (req, res)->
	renderOptions = {
		user: user
		markdown: markdown
		environment: process.env.USE
	}
	pdb.get("settings")
	.then (settings)->
		renderOptions.settings = settings
		res.render("feed", renderOptions)

	.catch (err)->
		# no settings avaiable
		res.render("feed", renderOptions)

# get the feed overview
app.get "/timeline", (req, res)->
	pdb.get("settings").then (settings)->
		res.render("timeline", {
			user: user
			markdown: markdown
			environment: process.env.USE
			settings: settings
		})

app.get "/rss", (req, res)->
	# query/map method
	map = (doc, emit)=>
		emit(doc._id, doc) if doc.type == 'post'

	# query options
	options = {
		include_docs: true
		descending: true
	}

	pdb.query map, options, (err, docs)->
		if docs
			# RSS Feed Setup
			feed = new RSS({
				title: 'MyFeed of '+ user.username
				description: "MyFeed Profile Page Feed"
				feed_url: process.env.DOMAIN_URL + 'rss'
				site_url: process.env.DOMAIN_URL
				pubDate: new Date()
			})
			docs.rows.forEach (item)->
				if item.doc.content || (item.doc.attachments && item.doc.attachments.length > 0)
					feed.item({
						title: item.doc.title
						description: markdown(item.doc.content).replace(/<(?:.|\n)*?>|[\n\r]/gm, '')
						url: process.env.DOMAIN_URL+'/post/'+item.doc._id
						author: process.env.USER_NAME
						date: new Date(item.doc.created)
						guid: item.doc._id
					})

			# send xml
			res.set('Content-Type', 'text/xml')
			res.send feed.xml()

# get the feed overview
app.get "/post/:id", (req, res)->

	# db get for meta tags :)
	# todo: google should  still parse
	# the website when we build everything
	# in the frontend!
	pdb.get req.params.id, (err, doc)->
		if doc

			# what kind of og:image
			if doc.attachments && doc.attachments.length > 0 && doc.attachments[0].thumbnail
				thumbnail = doc.attachments[0].thumbnail
			else
				thumbnail = "http://www.gravatar.com/avatar/"+user.emailhash+'?s=1200'

			pdb.get("settings").then (settings)->
				res.render("single", {
					doc: doc
					user: user
					markdown: markdown
					truncate: truncate
					thumbnail: thumbnail
					environment: process.env.USE
					settings: settings
				})

		# doc/page not found
		# return 404
		else
			res.status 404
			res.render("404", {
				user: user
				markdown: markdown
				environment: process.env.USE
			})

# get the feed overview
app.get "/login", (req, res)->
	pdb.get("settings").then (settings)->
		res.render("login", {
			user: user
			domain: process.env.DOMAIN_URL
			markdown: markdown
			settings: settings
		})

# get the feed via json api
app.get "/api/deleteforeign", (req, res)->

	map = (doc, emit)=>
		emit(doc._id) if doc.type == 'foreign_post'

	pdb.query map, {include_docs: true}, (err, docs)->
		if docs
			docs.rows.forEach (doc)->
				console.log("delete: ", doc.id)
				pdb.remove(doc.doc._id, doc.doc._rev)

		res.end "cool";

# get the feed via json api
app.post "/api/feed", (req, res)->

	# get own and foreign posts when 
	# api is used to get the timeline
	if req.body.type == "timeline"
		# query/map method
		map = (doc, emit)=>
			emit(doc._id) if doc.type == 'post' || doc.type == 'foreign_post' || doc.type == 'rss_post'

	# only emit our own posts
	# when no type specified
	else
		# query/map method
		map = (doc, emit)=>
			emit(doc._id) if doc.type == 'post'

	# query options
	options = {
		limit: 25
		include_docs: true
		descending: true
	}

	# after the db query
	callback = (err, docs)->
		if err 
			console.log err

		if docs
			# weve done a list query
			if docs.rows
				#correctDocKeys(docs)
				docs = docs.rows

			# we requested one document
			else
				docs = [{doc: docs}]

			# send it back to client
			res.setHeader 'Content-Type', 'application/json'
			res.end JSON.stringify {
				rows: docs
				user: {
					email: user.email
					emailhash: user.emailhash
					username: user.username
					domain: user.domain
				}
				markdown: markdown
			}

	# skip if startkey set
	if req.body.start
		options.startkey = req.body.start
		options.skip = 1

	# check if we only need one
	# document or a list
	if req.body.id
		# get one entry
		pdb.get req.body.id, callback
	else
		# query db for more
		pdb.query map, options, callback

# post a new post
app.post "/api/create", passport.authenticate('token', { session: false }), (req, res)->
	if(req.body.doc.content || req.body.doc.attachments.length > 0)
		doc = {}
		doc = req.body.doc
		doc.title = generateTitleFromPost(doc)
		doc._id = doc.created+'-'+urlify(doc.title)
		doc.type = "post"
		doc.user = {
			email: user.email
			emailhash: user.emailhash
			username: user.username
			domain: user.domain
		}
		pdb.put(doc).then (response)->
			# doc saved?
			res.json(response)
	else
		res.send('Fail');

# post a new post
app.post "/api/delete", passport.authenticate('token', { session: false }), (req, res)->
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
		process.env.SECRET)
	})

# scrape a website url
app.post "/api/scrapethis", passport.authenticate('token', { session: false }), (req, res)->
	myFeedScrape.scrape(req, res)

# add a new follower
app.post "/api/follow", passport.authenticate('token', { session: false }), (req, res)->
	doc = {}
	doc = req.body.doc
	doc.type = "follow"
	pdb.post(doc).then (response)->
		# doc saved?
		res.json(doc)

# list all followers
app.get "/api/followed", (req, res)->

	# query/map method
	query = (doc, emit)=>
		emit(doc._id, doc) if doc.type == 'follow'

	pdb.query query, {include_docs: true}, (err, docs)->
		if docs
			res.setHeader 'Content-Type', 'application/json'
			res.end JSON.stringify {
				rows: docs.rows
			}

app.post "/api/remove_follow", passport.authenticate('token', { session: false }), (req, res)->
	pdb.remove(req.body._id, req.body._rev)
	.then (response)->
		# doc deleted?
		res.end("true")
	.catch (err)->
		console.log err

app.post "/api/settings/bgimage", passport.authenticate('token', { session: false }), (req, res)->
	if req.body.datauri
		doc = {}
		pdb.get("settings").then (otherDoc)->
			doc._id = otherDoc._id
			doc._rev = otherDoc._rev
			doc.bgimage = req.body.datauri
			pdb.put(doc).then (response)->
				# doc saved?
				res.json(response)
		.catch (err)-> console.log "no settings doc available? ", err

# 404 page
app.use (req, res, next)->
	res.status 404
	res.render("404", {
		user: user
		markdown: markdown
		environment: process.env.USE
	})

server = app.listen process.env.SERVERPORT, ()->
	console.log "Listening....", server.address().port
