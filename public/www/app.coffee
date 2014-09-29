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

# generates a title from the post information
# when theres no content, we take the
# title of the first attachment
generateTitleFromPost = (doc)->

	# are there some content?
	if doc.content && doc.content.length > 0
		strippedContent = markdown(doc.content).replace(/<(?:.|\n)*?>/gm, '')

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

app.get "/rss", (req, res)->
	pdb.allDocs {include_docs: true}, (err, docs)->
		if docs
			# RSS Feed Setup
			feed = new RSS({
				title: 'MyFeed of '+ user.username
				description: "MyFeed Profile Page Feed"
				feed_url: process.env.DOMAIN_URL + 'feed'
				site_url: process.env.DOMAIN_URL
				pubDate: new Date()
			})
			docs.rows.forEach (item)->
				if item.doc.content || item.doc.attachments.length > 0
					console.log 
					feed.item({
						title: generateTitleFromPost(item.doc)
						description: item.doc.content
						url: process.env.DOMAIN_URL+'post/'+item.doc._id
						author: process.env.USER_NAME
						date: new Date(item.doc.created)
						guid: item.doc._id
					})

			# send xml
			# res.set('Content-Type', 'application/rss+xml')
			res.send feed.xml()

# get the feed overview
app.get "/post/:id", (req, res)->
	pdb.get req.params.id, (err, doc)->
		if !doc.title
			doc.title = generateTitleFromPost(doc)
			#pdb.put(doc)

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
