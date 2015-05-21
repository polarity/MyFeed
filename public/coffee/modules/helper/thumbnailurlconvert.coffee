window.HELP = {}

# takes the a thumb "url of og:image" tag and the
# "url of the html document" and convert the thumb
# urls to correct absolute urls
# 
# "//domain.tld/path/img.gif" -> "http://domain.tld/path/img.gif"
# "/path/img.gif" -> "http://domain.tld/path/img.gif"
# "img.gif" -> "http://domain.tld/path/img.gif"
HELP.thumbnailUrlConvert = (thumbnailUrl, url)->

	# thumbnail exists?
	if thumbnailUrl

		if thumbnailUrl.substr(0,1) == "/" && thumbnailUrl.substr(1,1) != "/"
			# thumb on the same domain
			# thumb relative url from root
			# lacking protocol + domain
			# -> "/path/absolute/thumb.gif"
			# prepend domain to make it work
			urlObj = new URL(url)
			thumbnailUrl = urlObj.protocol+"//"+urlObj.hostname + thumbnailUrl

		else if thumbnailUrl.substr(0,1) != "/" && thumbnailUrl.substr(0,4) != "http"
			# thumb on the same domain
			# thumb relative to document linked
			# lacking protocol + domain + root slash
			# -> "path/relative/thumb.gif"
			# prepend domain and document path
			urlDomainPath = url.substr(0, url.lastIndexOf("/"))
			thumbnailUrl =  urlDomainPath + thumbnailUrl

		else if thumbnailUrl.substr(0,2) == "//"
			# thumb on another domain, url lacking protocol
			# lacking protocol
			# -> "//domain/path/thumb.gif"
			thumbnailUrl =  "http:"+thumbnailUrl

	return thumbnailUrl