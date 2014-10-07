module.exports = (grunt) ->
	urlRewrite = require 'grunt-connect-rewrite'
	config =

		pkg: '<json:package.json>'

		# the watch task
		# compile on file change
		watch:
			options:
				livereload: false
				spawn: false

			coffee:
				files: ['src/coffee/**/*.coffee']
				tasks: [
					'concat:coffee',
					'coffee:dev',
					"bower_concat",
					"concat:app",
					"uglify:dev",
					'clean'
				]

			stylus:
				files: ['src/stylus/*.styl']
				tasks: ['stylus:dev']

			images:
				files: ['src/*']
				tasks: ['imagemin']

			fonts:
				files: ['src/fonts/*']
				tasks: ['copy:fonts']

		# compile stylus files
		stylus:
			# target static html
			dev:
				options:
					compress: false

				files: [
					"www/css/main.css": "src/stylus/main.styl"
				]

		coffee:
			options:
				bare: true
			dev:
				files:
					'.tmp/js/concat.js': ['.tmp/coffee/concat.coffee']

		copy:
			dev_images:
				files: [
					{
						expand: true
						cwd: 'src/img/'
						src: ['**/*']
						dest: 'www/img/'
					}
				]
			fonts:
				files: [
					{
						expand: true
						cwd: 'src/fonts/'
						src: ['**/*']
						dest: 'www/fonts/'
					}
				]
			svg:
				files: [
					{
						expand: true
						cwd: 'src/svg/'
						src: ['**/*']
						dest: 'www/svg/'
					}
				]
			copy_complete_js:
				files:
					"www/js/complete.js": [".tmp/js/complete.js"]

		uglify:
			dev:
				options:
					compress: true
					beautify: false
					report: true
				files:
					"www/js/complete.js": [".tmp/js/complete.js"]
		concat:
			coffee:
				src: [
					'src/coffee/bootstrap.coffee',
					'src/coffee/modules/**/*.coffee',
					'src/coffee/main.coffee'
				]
				dest: '.tmp/coffee/concat.coffee'

			app:
				src: ['.tmp/js/libraries.js', '.tmp/js/concat.js']
				dest: ".tmp/js/complete.js"

		bower_concat:
			all:
				dest: '.tmp/js/libraries.js'
				dependencies:
					'freewall': 'jquery'
				mainFiles:
					'markdown': 'lib/markdown.js'

	# init the Project configuration
	# from above
	grunt.initConfig config

	# load all needed tasks
	# install them via "npm install"
	# in the directory root
	grunt.loadNpmTasks 'grunt-contrib-watch'
	grunt.loadNpmTasks 'grunt-contrib-imagemin'
	grunt.loadNpmTasks 'grunt-contrib-copy'
	grunt.loadNpmTasks 'grunt-contrib-concat'
	grunt.loadNpmTasks 'grunt-contrib-coffee'
	grunt.loadNpmTasks 'grunt-contrib-uglify'
	grunt.loadNpmTasks 'grunt-contrib-stylus'
	grunt.loadNpmTasks 'grunt-bower-concat'

	# custom task: create the build dir
	grunt.registerTask 'clean', 'Deletes Temp Files', ()->
		grunt.file.delete('.tmp')

	# Default task:
	# run all above configured tasks
	# in this order when the user calls "grunt" in the project root
	grunt.registerTask 'dev', ["watch"]
	grunt.registerTask 'default', [
		'concat:coffee',
		'coffee:dev',
		"bower_concat",
		"concat:app",
		"uglify:dev",
		"clean",
		"stylus:dev",
		"copy:fonts",
		"copy:svg",
		"copy:dev_images"
	]
