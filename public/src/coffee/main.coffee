responsiveImageGrid = ()->
	$('.Gallerybox').each (i, box)->
		# collect parameters
		bestHeight = ($(window).height()/100)*50
		images = $(box).children("img").toArray()
		maxWidth = $(box).width()-40

		# call the method
		justifiedImageRows(bestHeight, images, maxWidth)


$ () ->
	$(window).load responsiveImageGrid
	$(window).resize responsiveImageGrid