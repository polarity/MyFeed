AuthController = ($scope, $timeout, $http) ->

	$scope.username = ""
	$scope.password = ""

	$scope.sendLogin = (username, password)->
		$http({
			url: "/api/login/"
			method: "POST"
			data: {
				'username': username
				'password': password
			}
		})
		.success( (data)-> console.log "login:", data )
		.error( (err)-> console.log "login:", err )

AuthController.$inject = ['$scope', '$timeout', '$http']
window.app.controller "AuthController", AuthController