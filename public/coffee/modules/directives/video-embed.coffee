Directive = ($sce)->
	restrict: 'EA'
	scope: { code: '@'}
	replace: true
	template: '<div style="width:100%; height:0; padding-bottom: 56%; position: relative;"><iframe style="position: absolute; left: 0; top: 0;" ng-src="{{url}}" width="100%" height="100%" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe></div>'
	link: (scope)->
		scope.$watch 'code', (newVal)->

			if(newVal.indexOf('vimeo.com') != -1)
				platform = 'vimeo'
				video_id = newVal.match(/\/(\d+)/)[1]

			if(newVal.indexOf('youtube.com') != -1 || newVal.indexOf('youtu.be') != -1)
				platform = 'youtube'
				video_id = newVal.match(/.*(?:youtu.be\/|v\/|u\/\w\/|embed\/|watch\?v=)([^#\&\?]*).*/)[1]

			if newVal && platform == 'vimeo'
				scope.url = $sce.trustAsResourceUrl('http://player.vimeo.com/video/'+video_id+'?title=0&amp;byline=0&amp;portrait=0&amp;color=24a8bf')
			if newVal && platform == 'youtube'
				scope.url = $sce.trustAsResourceUrl('https://www.youtube.com/embed/'+video_id)

# Angular Foo
# Since Angular infers the controller's dependencies from the 
# names of arguments to the controller's constructor function, 
# if you were to minify the JavaScript code for PhoneListCtrl 
# controller, all of its function arguments would be minified 
# as well, and the dependency injector would not be able to 
# identify services correctly.
# http://docs.angularjs.org/tutorial/step_05
Directive.$inject = ['$sce']
window.app.directive 'videoEmbed', Directive