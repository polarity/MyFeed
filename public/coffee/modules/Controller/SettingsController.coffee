Controller = ($scope, LoginService, $http, $timeout) ->

	$scope.login = LoginService

	$scope.upload =  (datauri)->
		$http({
			url: "/api/settings/bgimage"
			method: "POST"
			data: {datauri: datauri, "access_token": $scope.login.token}
		})
		.success (doc)-> console.log doc
		.error( (err)-> console.log err )

# Angular Foo
# Since Angular infers the controller's dependencies from the 
# names of arguments to the controller's constructor function, 
# if you were to minify the JavaScript code for PhoneListCtrl 
# controller, all of its function arguments would be minified 
# as well, and the dependency injector would not be able to 
# identify services correctly.
# http://docs.angularjs.org/tutorial/step_05
Controller.$inject = ["$scope", "LoginService", "$http", "$timeout"]
window.app.controller 'SettingsController', Controller