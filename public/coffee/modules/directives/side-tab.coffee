Directive = ($sce, $timeout)->
	restrict: 'E'
	scope: { 
		sidebarStatus: '='
		currentUrl: '='
	}
	replace: false
	template: '\
		<section style="background-color: #fff; width: 50%; height: 100%; position: fixed; right: 0; border-left: 4px solid #fff;">\
			<div class="sidetab-nav" style="position: absolute; top: 46px; width: 100%; height: 50px; z-index: 1; background-color: #333;">
				<a ng-click="closeSideTab()" style="padding: 12px 15px; display: inline-block; text-decoration: underline; color:#fff;">close sidebar</a>
			</div>\
			<iframe \
				name="sidetab"\ 
				src="{{cleanUrl}}" style="width: 100%; height: 100%; position: absolute; padding-top: 100px;"></iframe>\
		</section>'
	link: (scope, element, attr)->

		scope.$watch "currentUrl", (o, n)->
			if o != n
				console.log("url changed: ", scope.currentUrl, o, n )
				scope.cleanUrl = $sce.trustAsResourceUrl(scope.currentUrl);
				scope.sidebarStatus = "open"
				element.css({display: "block"})

		scope.closeSideTab = ()->
			scope.sidebarStatus = "closed"
			element.css({display: "none"})

# Angular Foo
# Since Angular infers the controller's dependencies from the 
# names of arguments to the controller's constructor function, 
# if you were to minify the JavaScript code for PhoneListCtrl 
# controller, all of its function arguments would be minified 
# as well, and the dependency injector would not be able to 
# identify services correctly.
# http://docs.angularjs.org/tutorial/step_05
Directive.$inject = ['$sce', '$timeout']
window.app.directive 'sideTab', Directive