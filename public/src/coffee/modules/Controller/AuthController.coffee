window.app.controller "AuthController", ($scope, LoginService, $http, $timeout) ->

	$scope.login = LoginService

	# store it locally
	if window.localStorage && localStorage['token']
		$scope.login.token = localStorage['token']

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
			# store it locally
			if window.localStorage
				localStorage['token'] = data.token

			# get the token
			$timeout ()-> 
				$scope.login.token = data.token
				$scope.login.info = ""

		.error (err)-> 
			$scope.login.info = "Kein Login möglich: " + err

	$scope.sendLogout = ()->
		$scope.login.token = ""
		if window.localStorage
			localStorage.clear()