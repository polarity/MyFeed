responsiveImageGrid = ()->
	$('.Gallerybox').each (i, box)->
		# collect parameters
		bestHeight = ($(window).height()/100)*50
		images = $(box).children("img").toArray()
		maxWidth = $(box).width()-40

		# call the method
		justifiedImageRows(bestHeight, images, maxWidth)

onKeyUp = ()->
	urlRegex = /(\b(https?|ftp|file):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])/ig
	urlArr = []
	urlArr = $(this).val().match(urlRegex)
	window.PostObject = {
		text: $(this).val()
		urls: urlArr
	}
	showPostObject(window.PostObject)

showPostObject = (data) ->

$ () ->
	window.PostObject = {}
	$(window).load responsiveImageGrid
	$(window).resize responsiveImageGrid
	$(".createpost-input").on "keyup", onKeyUp
