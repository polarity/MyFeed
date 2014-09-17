window.app.controller "PostListController", ($scope, $timeout, $http, PostsService, LoginService) ->

	$scope.Posts = PostsService
	$scope.login = LoginService

	# just parse all found url
	$scope.getPosts = (url)->
		$http({
			url: "/api/feed"
			method: "GET"
		})
		.success( (data)->
			data.rows.forEach (item)->
				$scope.Posts.push(item.doc)
		)
		.error( (err)-> console.log err )

	$scope.getPosts()

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
				"id": PostObject._id, 
				"access_token": $scope.login.token
			}
		})
		.success( (data)->
			console.log data
		)
		.error( (err)-> console.log err )
