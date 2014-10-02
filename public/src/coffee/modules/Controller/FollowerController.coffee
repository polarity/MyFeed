window.app.controller "FollowerController", ($scope, LoginService, $http, $timeout) ->

	$scope.login = LoginService
	$scope.followed = []

	$scope.getFollowed = ()->
		$http({
			url: "/api/followed"
			method: "GET"
		})
		.success( (data)->
			data.rows.forEach (item)->
				$scope.followed.push(item.doc)
		)
		.error( (err)-> console.log err )

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

		.success (doc)-> 
			$scope.followed.push(doc)
		.error (err)-> 
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
		.success( (data)->
			console.log 'gelöscht!'
		)
		.error( (err)-> console.log err )
