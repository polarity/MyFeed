CreatePostController = ($scope, $timeout) ->
	$scope.text = ""
	$scope.PostObject = {}

	$scope.parseText = ()->
		urlRegex = /(\b(https?|ftp|file):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])/ig
		urlArr = []
		urlArr = $scope.text.match(urlRegex)
		$scope.PostObject = {
			text: $scope.text
			urls: urlArr
		}

CreatePostController.$inject = ['$scope', '$timeout']
window.app.controller "CreatePostController", CreatePostController