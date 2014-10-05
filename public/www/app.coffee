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
truncate = require('truncate')
PouchDB = require('pouchdb')
RSS = require('rss')
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
user.domain = process.env.DOMAIN_URL

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


# generates a title from the post information
# when theres no content, we take the
# title of the first attachment
generateTitleFromPost = (doc)->
	# are there some content?
	if doc.content && doc.content.length > 0
		strippedContent = markdown(doc.content).replace(/<(?:.|\n)*?>/gm, '').trim()
		# console.log strippedContent
		# try to get the first line (100chars max) & until a line break
		strippedTitle = strippedContent.match(/^([\S\s]{0,100}\n)/g)
		if strippedTitle
			strippedTitle = strippedTitle[0].replace(/(\n)+/g, '')
			# take the first 80 chars and use it as a title
			return strippedTitle
		else
			# nothing found? just take 100 chars off the content
			return truncate(strippedContent, 100)

	# no content? maybe some attachments there?
	else if doc.attachments && doc.attachments.length > 0 && doc.attachments[0].title
		# take the title of the first 
		# attachment and use it as title
		return doc.attachments[0].title
	else
		return "rnd-"+Math.random()

# routes
#

# get the feed overview
app.get "/", (req, res)->
	res.render("feed", {
		user: user
		markdown: markdown
		environment: process.env.USE
	})

app.get "/rss", (req, res)->
	# query/map method
	query = (doc, emit)=>
		emit(doc._id, doc) if !doc.type || doc.type == 'post' 

	pdb.query query, {include_docs: true}, (err, docs)->
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
				if item.doc.content || item.doc.attachments.length > 0
					feed.item({
						title: item.doc.title
						description: item.doc.content
						url: process.env.DOMAIN_URL+'post/'+item.doc._id
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
			res.render("single", {
				doc: doc
				user: user
				markdown: markdown
				truncate: truncate
				environment: process.env.USER_NAME
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
app.post "/api/feed", (req, res)->

	# query/map method
	map = (doc, emit)=>
		emit(doc._id) if !doc.type || doc.type == 'post'

	# query options
	options = {
		limit: 5
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
				correctDocKeys(docs)
				docs = docs.rows

			# we requested one document
			else
				docs = [{doc: docs}]

			# send it back to client
			res.setHeader 'Content-Type', 'application/json'
			res.end JSON.stringify {
				rows: docs
				user: user
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
		secret)
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

server = app.listen process.env.SERVERPORT, ()->
	console.log "Listening....", server.address().port
