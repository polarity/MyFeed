window.app.filter "dateFormat", () ->
	return (date) ->
		moment(date).format("DD.MM.YYYY")