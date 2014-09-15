window.app.controller "CreatePostController", ($scope, LoginService, $timeout, $http, PostsService) ->

	$scope.posts = PostsService
	$scope.login = LoginService

	$scope.initCurrentPost = ()->
		# post ready post object
		$scope.PostObject = {
			title: ""
			content: ""
			attachments: []
			created: new Date().getTime()
			user: {}
		}

	$scope.initCurrentPost()

	$scope.parseText = ()->
		# url parsing
		urlRegex = /(\b(https?|ftp|file):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])/ig
		urlArr = []
		urlArr = $scope.PostObject.content.match(urlRegex)

		if urlArr
			urlArr.forEach (url)-> 
				parse = true
				$scope.PostObject.attachments.forEach (attachment)->
					if attachment.url == url
						parse = false

				if parse
					$scope.scrapeUrls(url)

	# just parse all found url
	$scope.scrapeUrls = (url)->
		$http({
			url: "/api/scrapethis/"
			method: "POST"
			data: {'url': url, "access_token": $scope.login.token}
		})
		.success( (data)-> $scope.PostObject.attachments.push(data) )
		.error( (err)-> console.log err )

	# removes an attachment from the array
	$scope.removeAttachment = (attachment)->
		index = $scope.PostObject.attachments.indexOf(attachment)
		$scope.PostObject.attachments.splice(index,1)

	# create the post
	$scope.sendPostObject = (PostObject)->
		$http({
			url: "/api/create/"
			method: "POST"
			data: {doc: PostObject, "access_token": $scope.login.token}
		})
		.success (data)-> 
			$timeout ()->
				$scope.posts.push($scope.PostObject)
				$scope.initCurrentPost()

		.error( (err)-> console.log err )