Directive = ($http)->
	restrict: 'E'
	replace: true
	transclude: true
	template: '\
		<div class="loading">\
			<a href="http://scriptshit.de/lena-game/" class="loadingText">
				<img alt="Lena the turtle running! Click to start game." src="data:image/gif;base64,R0lGODlhFAAPAPMAAFZWVltbW2tra29vb4KCgpaWlqGhobOzs7m5uQAAAAAAAAAAAAAAAAAAAAAAAAAAACH5BA0KAAkAIf8LTkVUU0NBUEUyLjADAQAAACwAAAAAFAAPAAAETDDJSSeqOKer+0agVyHHAHLaoRKD4RoodrBDTYjJXAc2TvMAws1TCvACrJNGyBsEWYnBsFKTAgCDQmHauSIJLq5HWBUvhZKeqEZhVyIAIfkEDQoADAAsAAAAABQADwCDVlZWW1tba2trb29vdXV1goKClpaWoaGhra2ts7Ozubm54eHhAAAAAAAAAAAAAAAABFOQyUmnqjizq/tWyuJVSjKAYpeshYIYCMJlSTHcg6HDWn0Ht8KIYRsAAQOhxxQ4Fp4bzRM4ADxPoEySQAXoBoykNhiwHg7KYfgJVa+D7jAhDMZEAAAh+QQNCgAIACwAAAAAFAAPAINWVlZbW1tvb2+CgoKWlpahoaGzs7O5ubkAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAESRDJSeepOKOr+z6gVx2GAHKaoQ5C4RYoZrBCPYjIXAc2TvOAwc1TCvACrJNGyBMEWQjBsFLbAQQEwrQD6ApdW49UGBazyuJqJwIAOw=="> Loading....</a>\
			<div ng-transclude style="display: none"></div>\
		</div>'
	link: (scope, element, attr)->

		scope.isLoading = ()->
			return $http.pendingRequests.length > 0

		scope.$watch scope.isLoading, (val)->
			if (val)
				$(element).find('a').show()
				$(element).find('div').hide()
			else
				$(element).find('a').hide()
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