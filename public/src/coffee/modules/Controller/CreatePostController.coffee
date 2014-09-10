CreatePostController = ($scope, $timeout, $http) ->

	# post ready post object
	$scope.PostObject = {
		title: ""
		content: ""
		attachments: []
		created: new Date()
	}

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
			data: {'url': url}
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
			data: PostObject
		})
		.success( (data)-> console.log('success', data) )
		.error( (err)-> console.log err )

CreatePostController.$inject = ['$scope', '$timeout', '$http']
window.app.controller "CreatePostController", CreatePostController