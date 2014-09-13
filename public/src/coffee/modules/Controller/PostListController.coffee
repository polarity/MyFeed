PostListController = ($scope, $timeout, $http) ->

	$scope.Posts = []

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

CreatePostController.$inject = ['$scope', '$timeout', '$http']
window.app.controller "CreatePostController", CreatePostController