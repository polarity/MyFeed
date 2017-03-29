Controller = ($scope, LoginService, $http, $timeout) ->

	$scope.login = LoginService
	$scope.followed = []

	$scope.getFollowed = ()->
		$http({
			url: "/api/followed"
			method: "GET"
		})
		.then( (data)->
			if data
				data.rows.forEach (item)->
					$scope.followed.push(item.doc)
		)
		.catch( (err)-> console.log err )

	$scope.getFollowed()

	# send username and passwort from the login
	# inputs to the server for validation
	$scope.addFollower = (domain)->
		$http({
			url: "/api/follow"
			method: "POST"
			data: {
				doc: {
					"created": new Date().getTime()
					"domain": domain
				}
				"access_token": $scope.login.token
			}
		})

		.then (doc)->
			$scope.followed.push(doc)
		.catch (err)->
			console.log(err)

	$scope.removeFollower = (follower)->
		# find index of this post object in our list
		index = $scope.followed.findIndex (item) -> item._id == follower._id

		# delete it
		$scope.followed.splice(index, 1)

		# send delete post to server
		# and request the deletion
		# of the object with this id
		$http({
			url: "/api/remove_follow"
			method: "POST"
			data: {
				"_id": follower._id, 
				"_rev": follower._rev, 
				"access_token": $scope.login.token
			}
		})
		.then( (data)->
			console.log 'gelöscht!'
		)
		.catch( (err)-> console.log err )

# Angular Foo
# Since Angular infers the controller's dependencies from the 
# names of arguments to the controller's constructor function, 
# if you were to minify the JavaScript code for PhoneListCtrl 
# controller, all of its function arguments would be minified 
# as well, and the dependency injector would not be able to 
# identify services correctly.
# http://docs.angularjs.org/tutorial/step_05
Controller.$inject = ["$scope", "LoginService", "$http", "$timeout"]
window.app.controller 'FollowerController', Controller