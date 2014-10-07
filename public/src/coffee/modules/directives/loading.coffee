window.app.directive "loading", ($http)->
	restrict: 'E'
	replace: true
	transclude: true
	template: '<div class="loading"><span class="loadingText">Loading....</span><div ng-transclude style="display: none"></div></div>'
	link: (scope, element, attr)->
		console.log element.text()
		scope.isLoading = ()->
			return $http.pendingRequests.length > 0

		scope.$watch scope.isLoading, (val)->
			if (val)
				$(element).find('span').show()
				$(element).find('div').hide()
			else
				$(element).find('span').hide()
				$(element).find('div').show()
