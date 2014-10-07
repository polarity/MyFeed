Directive = ($sce, $http)->
	restrict: 'EA'
	scope: { code: '@'}
	replace: true
	template: '<div style="width:100%; height="450" ng-bind-html="embedHTML"></div>'
	link: (scope)->
		scope.$watch 'code', (newVal)->
			scope.embedHTML = $sce.trustAsHtml(newVal)

# Angular Foo
# Since Angular infers the controller's dependencies from the 
# names of arguments to the controller's constructor function, 
# if you were to minify the JavaScript code for PhoneListCtrl 
# controller, all of its function arguments would be minified 
# as well, and the dependency injector would not be able to 
# identify services correctly.
# http://docs.angularjs.org/tutorial/step_05
Directive.$inject = ['$sce', '$http']
window.app.directive 'soundEmbed', Directive