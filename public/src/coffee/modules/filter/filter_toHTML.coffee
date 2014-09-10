window.app.filter 'toHTML', ()->
	(text)->
		markdown.toHTML(text)