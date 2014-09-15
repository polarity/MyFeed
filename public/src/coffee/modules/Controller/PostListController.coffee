window.app.controller "PostListController", ($scope, $timeout, $http, PostsService) ->

	$scope.Posts = PostsService

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