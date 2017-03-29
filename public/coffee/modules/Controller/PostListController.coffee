Controller = ($scope, $timeout, $http, PostsService, LoginService) ->

		$scope.Posts = PostsService
		$scope.login = LoginService
		$scope.start = false
		$scope.type = false
		$scope.end = false

		# get all posts from the backend
		$scope.getPosts = (id, start, type)->
			id = false if !id
			$scope.start = if !start then false  else start
			$scope.type = if !type then false else type

			$http({
				url: "/api/feed"
				method: "POST"
				data: {
					id: id
					start: $scope.start
					type: $scope.type
				}
			})
			.then( (data)->
				if data && data.rows && data.rows.length > 1
					data.rows.forEach (item)->
						$scope.Posts.push(item.doc)

					# remember last id
					$scope.end = data.rows[data.rows.length-1].id
			)
			.catch( (err)-> console.log err )

		$scope.showMore = (type)->
			$scope.getPosts(false, $scope.end, type)

		$scope.delete = (PostObject)->
			# no login, no delete
			return false if !$scope.login.token

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
Controller.$inject = ['$scope', '$timeout', '$http', 'PostsService', 'LoginService']
window.app.controller 'PostListController', Controller