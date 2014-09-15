window.app.filter "dateFromNow", () ->
	return (date) ->
		moment(date).fromNow()