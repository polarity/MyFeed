Directive = ($sce, $http)->
	restrict: 'EA'
	scope: { code: '@'}
	replace: true
	template: '<div style="width:100%; height="450" ng-bind-html="embedHTML"></div>'
	link: (scope)->
		scope.$watch 'code', (newVal)->

			if(newVal.indexOf('soundcloud.com') != -1)
				$http({
					url: 'http://soundcloud.com/oembed'
					params: {
						format: 'json'
						url: 'https://soundcloud.com/insight-music/sets/vacant-trauma-ep'
					}
				})
				.success (res)->
					scope.embedHTML = $sce.trustAsHtml(res.html)

				.catch (err)->
					console.log err

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