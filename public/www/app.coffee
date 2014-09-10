Express = require "express"
CouchDB = require "couchdb-api"
md5 = require "md5"
dotenv = require "dotenv"
markdown = require("node-markdown").Markdown
stylus = require 'stylus'
bodyParser = require 'body-parser'
request = require 'request'
cheerio = require 'cheerio'

# init
dotenv.load()
app = Express()
app.set 'view engine', 'jade'

app.use stylus.middleware({src: __dirname + '/stylus', dest: __dirname + '/css'})
app.use '/css', Express.static(__dirname + '/css')
app.use '/js', Express.static(__dirname + '/js')
app.use bodyParser.json()

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
#

# get the feed overview
app.get "/feed", (req, res)->
	db.allDocs {include_docs: true}, (err, docs)->
		if docs
			res.render("feed", {
				rows: docs.rows.sort(sortByDate).reverse(), 
				user: user,
				markdown: markdown
			})

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

# scrape a website url
app.post "/api/scrapethis", (req, res)->

	# scrape the website
	scrape req.body.url, (error, response, html)->

		if req.body.url.indexOf('flickr.com') != -1
			parsedObj = parseFlickr(html)
		else if req.body.url.indexOf('.jpg') != -1 || req.body.url.indexOf('.jpeg') != -1
			parsedObj = parseImage(req.body.url)
		else
			parsedObj = parseRegularWebsite(html)

		# send headers and data back
		res.setHeader 'Content-Type', 'application/json'
		res.end JSON.stringify {
			title: parsedObj.title
			url: req.body.url
			excerpt: parsedObj.description
			thumb: parsedObj.thumbnail
			type: parsedObj.type
		}

# parse a image website
parseImage = (url)->
	return {
		title: ""
		description: ""
		thumbnail: url
		type: 'image'
	}

# parse a flickr website
parseFlickr = (html)->
	# load website into cheerio
	$ = cheerio.load html

	# get the title
	title = $('meta[property="og:title"]').attr('content')
	title = $('title').text() if !title 

	# get the description
	description = $('meta[property="og:description"]').attr('content')
	description = $('meta[name="description"]').attr('content') if !description 

	# get the thumb
	thumbnail = $('meta[property="og:image"]').attr('content')

	return {
		title: title
		description: description
		thumbnail: thumbnail
		type: 'image'
	}

# parse a regular website
# thx
parseRegularWebsite = (html)->
	# load website into cheerio
	$ = cheerio.load html

	# get the title
	title = $('meta[property="og:title"]').attr('content')
	title = $('title').text() if !title 

	# get the description
	description = $('meta[property="og:description"]').attr('content')
	description = $('meta[name="description"]').attr('content') if !description 

	# get the thumb
	thumbnail = $('meta[property="og:image"]').attr('content')

	apple_icon = $('link[rel="apple-touch-icon"][sizes="144x144"]').attr('href')
	if apple_icon && !thumbnail
		thumbnail = req.body.url+'/'+apple_icon

	return {
		title: title
		description: description
		thumbnail: thumbnail
		type: 'url'
	}

scrape = (url, callback)->
	# get the website
	request url, callback

server = app.listen 8000, ()->
	console.log "Listening....", server.address().port
