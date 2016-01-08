request = require('request')
feedparser = require('rssparser')

# own modules
getParams = require("./app_modules/getParamsFromString.coffee")
onFollowerResponse = require("./app_modules/parseFollowingApi.coffee")
onFollowerRssResponse = require("./app_modules/parseFollowingRss.coffee")

# reserve var
# set it in "module.exports"
# on the bottom
db = false

# parse the RSS feed of the foreign website
parseRssFeed = (error, response, html)->
	# should be rss: text/xml ~ application/xml
	# and give a 200
	if !error && response.statusCode == 200 && (/text\/xml/.test(response.headers['content-type']) || /application\/xml/.test(response.headers['content-type']))
		charset = getParams(response.headers['content-type'] || '').charset || "UTF-8"
		feedparser.parseURL row.doc.domain, {rssEncoding: charset}, (err, response)->
			onFollowerRssResponse(err, response, row.doc.domain, db)

# parse the response from the foreign website
parseFollowingResponse = (error, response, html)->
	# is myfeed? post should give 200 and app/json header:
	if !error && response.statusCode == 200 && response.headers['content-type']=='application/json'
		# parse myfeed!
		onFollowerResponse(error, response, html, row.doc.domain, db) if !error
	else
		# try get RSS feed instead / without api path
		request.get row.doc.domain, parseRssFeed

# when the pouchdb responds with an array
# of followed myfeeds
onDbResponse = (err, docs)->
	return false if !docs
	docs.rows.forEach (row)->
		# parse the response from the foreign website
		request.post row.doc.domain+'/api/feed', parseFollowingResponse

# called every nth time
# as long the app runs
onInterval = ()->
	# get some feed urls from the db
	map = (doc, emit)=> emit(doc._id, doc) if doc.type == 'follow'
	db.query map, {include_docs: true}, onDbResponse

# export to use this in our main app
module.exports = (pdb, delay)->
	db = pdb
	setInterval onInterval, delay
	onInterval()
