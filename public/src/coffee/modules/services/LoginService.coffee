window.app.service "LoginService", ($http, $timeout)->
	@username = ""
	@email = ""
	@emailhash = ""
	@password = ""
	@token = ""
	@info = ""
	@

	# check if user logged already in
	# via checking the local storage for
	# credentials
	if window.localStorage && localStorage['token']
		@token = localStorage['token']
		@username = localStorage['username']
		@email = localStorage['email']
		@emailhash = localStorage['emailhash']
