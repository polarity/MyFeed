module.exports = (str) ->
	params = str.split(';').reduce(((params, param) ->
		parts = param.split('=').map((part) ->
			part.trim()
		)
		if parts.length == 2
		  params[parts[0]] = parts[1]
		params
	), {})
	params
