Controller = ($scope, LoginService, $timeout, $http, PostsService) ->

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

		# watch user login changed
		# and stuff user data from the backend
		# to the new post
		$scope.$watch('login',( old, newval)->
			$scope.PostObject.user = {
				username: $scope.login.username
				email: $scope.login.email
				emailhash: $scope.login.emailhash
			}
		, true)

	# create a new post object on init
	$scope.initCurrentPost()

	$scope.parseText = ()->
		# url parsing
		urlRegex = /(\b(https?|ftp|file):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])/ig
		urlArr = []
		urlArr = $scope.PostObject.content.match(urlRegex)

		if urlArr
			urlArr.forEach (url)-> 
				# find url
				attachmentFound = $scope.PostObject.attachments.find (attachment)-> 
					attachment.url == url

				# scrape url only when 
				# is not scraped yet
				if !attachmentFound
					# push url first, so we only parse it once
					$scope.PostObject.attachments.push({url: url})
					# then scrape the url completely
					$scope.scrapeUrls(url)

	# just parse all found url
	$scope.scrapeUrls = (url)->
		$http({
			url: "/api/scrapethis/"
			method: "POST"
			data: {'url': url, "access_token": $scope.login.token}
		})

		.success (data)-> 
			# get temporary url object
			index = $scope.PostObject.attachments.findIndex (attachment)-> 
				attachment.url == url

			# thumbnail exists?
			if data.thumbnail

				# thumb relative url from root
				# prepend domain to make it work
				if data.thumbnail.substring(0,1) == "/"
					urlObj = new URL(url)
					data.thumbnail = urlObj.protocol+"//"+urlObj.hostname + data.thumbnail

				else if data.thumbnail.substring(0,7) != "http://" && data.thumbnail.substring(0,8) != "https://"
					# thumb relative to document linked
					# prepend domain and document path
					urlDomainPath = url.substr(0, url.lastIndexOf("/"))
					data.thumbnail =  urlDomainPath + data.thumbnail


			# overwrite url object
			$scope.PostObject.attachments[index] = data

		.error (err)-> 
			console.log err

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
		.success (doc)-> 
			$timeout ()->
				$scope.PostObject._id = doc.id
				$scope.PostObject._rev = doc.rev
				$scope.PostObject.type = 'post'
				# push the post object to the PostList
				$scope.posts.push($scope.PostObject)
				# create a new post object on init
				$scope.initCurrentPost()

		.error( (err)-> console.log err )

# Angular Foo
# Since Angular infers the controller's dependencies from the 
# names of arguments to the controller's constructor function, 
# if you were to minify the JavaScript code for PhoneListCtrl 
# controller, all of its function arguments would be minified 
# as well, and the dependency injector would not be able to 
# identify services correctly.
# http://docs.angularjs.org/tutorial/step_05
Controller.$inject = ["$scope", "LoginService", "$timeout", "$http", "PostsService"]
window.app.controller 'CreatePostController', Controller