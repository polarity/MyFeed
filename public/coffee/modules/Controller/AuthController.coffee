Controller = ($scope, LoginService, $http, $timeout) ->

	$scope.login = LoginService

	# send username and passwort from the login
	# inputs to the server for validation
	$scope.sendLogin = (username, password)->
		$http({
			url: "/api/login/"
			method: "POST"
			data: {
				'username': $scope.login.username
				'password': $scope.login.password
			}
		})

		.success (data)-> 
			# store only the token and some
			# infos on the browser localStorage
			if window.localStorage
				localStorage['token'] = data.token
				localStorage['username'] = data.user.username
				localStorage['email'] = data.user.email
				localStorage['emailhash'] = data.user.emailhash

			# set the data to the current
			# service so all other controllers
			# can react to it
			$timeout ()-> 
				$scope.login.token = data.token
				$scope.login.username = data.user.username
				$scope.login.email = data.user.email
				$scope.login.emailhash = data.user.emailhash
				$scope.login.info = ""

		.error (err)-> 
			# something went wrong
			# not logged in, set a info message
			$scope.login.info = "Kein Login möglich: " + err

	# user wants to log out
	# empty all values and clear the 
	# localStorage.
	$scope.sendLogout = ()->
		$scope.login.token = ""
		$scope.login.username = ""
		$scope.login.email = ""
		$scope.login.emailhash = ""
		if window.localStorage
			localStorage.clear()

# Angular Foo
# Since Angular infers the controller's dependencies from the 
# names of arguments to the controller's constructor function, 
# if you were to minify the JavaScript code for PhoneListCtrl 
# controller, all of its function arguments would be minified 
# as well, and the dependency injector would not be able to 
# identify services correctly.
# http://docs.angularjs.org/tutorial/step_05
Controller.$inject = ['$scope', 'LoginService', '$http', '$timeout']
window.app.controller 'AuthController', Controller