twttr = require("twitter-widgets")

Directive = ($sce, $timeout)->
	restrict: 'EA'
	scope: { code: '@'}
	replace: true
	template: '<div class="oembedWrapper" ng-bind-html="embedHTML"></div>'
	link: (scope)->
		scope.$watch 'code', (newVal)->
			scope.embedHTML = $sce.trustAsHtml(newVal)
			$timeout ()->
				# load the twitter widgets after drawing
				if twttr
					twttr.load()
				# parse instagram pics on every repaint
				if instgrm
					instgrm.Embeds.process()

# Angular Foo
# Since Angular infers the controller's dependencies from the 
# names of arguments to the controller's constructor function, 
# if you were to minify the JavaScript code for PhoneListCtrl 
# controller, all of its function arguments would be minified 
# as well, and the dependency injector would not be able to 
# identify services correctly.
# http://docs.angularjs.org/tutorial/step_05
Directive.$inject = ['$sce', '$timeout']
window.app.directive 'oembed', Directive