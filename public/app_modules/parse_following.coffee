feedparser = require('rssparser')
request = require('request')

# own modules
onFollowerResponse = require("./parseFollowingApi.coffee")
onFollowerRssResponse = require("./parseFollowingRss.coffee")
getParams = require("./getParamsFromString.coffee")

# parse the RSS feed of the foreign website
parseRssFeed = (domain, db, error, response, html)->
	# should be rss: text/xml ~ application/xml
	# and give a 200
	if !error && response.statusCode == 200 &&
		(
			/text\/xml/.test(response.headers['content-type']) ||
			/application\/xml/.test(response.headers['content-type']) ||
			/application\/rss\+xml/.test(response.headers['content-type']) ||
			/text\/html/.test(response.headers['content-type'])
		)
		charset = getParams(response.headers['content-type'] || '').charset || "UTF-8"
		feedparser.parseURL domain, {rssEncoding: charset}, (err, response)->
			onFollowerRssResponse(err, response, domain, db)
	# else
		# if error
			# console.log("-> RSS Fehler", error, " -> ", domain)
		# if response
			# console.log("-> Code: ", response.statusCode, ", Header:", response.headers['content-type'], " -> ", domain)

# parse the response from the foreign website
onUrlResponse = (url, db, error, response, html)->
	# is myfeed? post should give 200 and app/json header:
	if !error && response.statusCode == 200 && response.headers['content-type']=='application/json'
		# parse myfeed!
		onFollowerResponse(error, response, html, url, db) if !error
	else
		rssUrl = url.replace("/api/feed", "")
		# try get RSS feed instead / without api path
		request.get rssUrl, parseRssFeed.bind(undefined, rssUrl, db)

module.exports = parseFollowing = (url, db)->
	request.get url, onUrlResponse.bind(undefined, url, db)
