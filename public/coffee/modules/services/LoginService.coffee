Service = ($http, $timeout)->
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

# Angular Foo
# Since Angular infers the controller's dependencies from the 
# names of arguments to the controller's constructor function, 
# if you were to minify the JavaScript code for PhoneListCtrl 
# controller, all of its function arguments would be minified 
# as well, and the dependency injector would not be able to 
# identify services correctly.
# http://docs.angularjs.org/tutorial/step_05
Service.$inject = ['$http', '$timeout']
window.app.service 'LoginService', Service