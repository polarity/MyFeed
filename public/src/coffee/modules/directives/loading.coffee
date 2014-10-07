Directive = ($http)->
	restrict: 'E'
	replace: true
	transclude: true
	template: '<div class="loading"><span class="loadingText">Loading....</span><div ng-transclude style="display: none"></div></div>'
	link: (scope, element, attr)->

		scope.isLoading = ()->
			return $http.pendingRequests.length > 0

		scope.$watch scope.isLoading, (val)->
			if (val)
				$(element).find('span').show()
				$(element).find('div').hide()
			else
				$(element).find('span').hide()
				$(element).find('div').show()

# Angular Foo
# Since Angular infers the controller's dependencies from the 
# names of arguments to the controller's constructor function, 
# if you were to minify the JavaScript code for PhoneListCtrl 
# controller, all of its function arguments would be minified 
# as well, and the dependency injector would not be able to 
# identify services correctly.
# http://docs.angularjs.org/tutorial/step_05
Directive.$inject = ['$http']
window.app.directive 'loading', Directive