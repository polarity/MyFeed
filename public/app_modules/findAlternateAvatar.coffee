request = require('request')
cheerio = require('cheerio');
thumbnailUrlConvert = require("./ogImageUrlConvert.coffee")

# try to get an Avatar or thumbnail for a
# website. favicon, logo.png or some random
# image from the page. we need this for
# a nice interface 
module.exports = (hostname,  callback)->
	request.get "http://"+hostname+"/favicon.ico", (error, response, html)->
		# should deliver an 200 and shouldnt be 0 bytes
		# some webserver (microsoft) deliver 200 AND an ico with 0 bytes
		if !error && response.statusCode == 200 && response.headers['content-length'] != "0"
			callback("http://"+hostname+"/favicon.ico") 
		else
			# try to get ANY image from the index webpage 
			# of the feed
			request.get  "http://"+hostname, (error, response, html)->
				if !error
					# where trying to get different images
					# from the webpage
					thumbnail = undefined

					# get all image tags from the webpage
					$ = cheerio.load(html)
					images = $("img")

					# images is array?
					if images.length > 0
						# step each image
						images.each (index, img)->
							# try to sneak logo :)
							if /logo/.test($(img).attr("src"))
								thumbnail = $(img).attr("src")

					# still no image? get ANY img you find
					if !thumbnail
						thumbnail = $("img").attr("src")

					# convert url
					if(thumbnail)
						thumbnail = thumbnailUrlConvert(thumbnail, "http://"+hostname)

					# return
					callback(thumbnail)
