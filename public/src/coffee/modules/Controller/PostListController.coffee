window.app.controller "PostListController", ($scope, $timeout, $http, PostsService, LoginService) ->

	$scope.Posts = PostsService
	$scope.login = LoginService
	$scope.start = false
	$scope.end = false

	# just parse all found url
	$scope.getPosts = (id, start)->
		id = false if !id
		start = false if !start

		$http({
			url: "/api/feed"
			method: "POST"
			data: {
				id: id
				start: start
			}
		})
		.success( (data)->
			data.rows.forEach (item)->
				$scope.Posts.push(item.doc)

			# remember last id
			if data.rows.length > 0
				$scope.end = data.rows[data.rows.length-1].id
				console.log $scope.end
		)
		.error( (err)-> console.log err )

	$scope.getPosts()

	$scope.showMore = ()->
		console.log
		$scope.getPosts(false, $scope.end)

	$scope.delete = (PostObject)->
		# find index of this post object in our list
		postIndex = $scope.Posts.findIndex (item) -> item._id == PostObject._id
		# delete it
		$scope.Posts.splice(postIndex, 1)

		# send delete post to server
		# and request the deletion
		# of the object with this id
		$http({
			url: "/api/delete"
			method: "POST"
			data: {
				"_id": PostObject._id, 
				"_rev": PostObject._rev, 
				"access_token": $scope.login.token
			}
		})
		.success( (data)->
			console.log 'gelöscht!'
		)
		.error( (err)-> console.log err )
