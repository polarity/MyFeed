module.exports = (grunt) ->
	urlRewrite = require 'grunt-connect-rewrite'
	config =

		pkg: '<json:package.json>'

		# the watch task
		# compile on file change
		watch:
			options:
				livereload: true
				spawn: false

			coffee:
				files: ['src/coffee/**/*.coffee']
				tasks: [
					'concat:coffee',
					'coffee:dev',
					"bower_concat",
					"concat:app",
					"replace:socket_config_dev",
					"copy:copy_complete_js",
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
			dist:
				options:
					compress: true

				files: [
					"dist/css/main.css": "src/stylus/main.styl"
				]

			# target static html
			dev:
				options:
					compress: false

				files: [
					"www/css/main.css": "src/stylus/main.styl"
				]

		# compile scss files
		sass:
			dist:
				options:
					style: "expanded"

				files: [
					"dist/css/main.css": "src/scss/main.scss"
				]

			# target static html
			dev:
				options:
					style: "compressed"

				files: [
					"dev/css/main.css": "src/scss/main.scss"
				]

		coffee:
			dist:
				files:
					'.tmp/js/concat.js': ['.tmp/coffee/concat.coffee']
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
						dest: 'dev/img/'
					}
				]
			dist_images:
				files: [
					{
						expand: true
						cwd: 'src/img/'
						src: ['**/*']
						dest: 'dist/img/'
					}
				]
			dist_fonts:
				files: [
					{
						expand: true
						cwd: 'src/fonts/'
						src: ['**/*']
						dest: 'dist/fonts/'
					}
				]

			fonts:
				files: [
					{
						expand: true
						cwd: 'src/fonts/'
						src: ['**/*']
						dest: 'dev/fonts/'
					}
				]
			svg:
				files: [
					{
						expand: true
						cwd: 'src/svg/'
						src: ['**/*']
						dest: 'dev/svg/'
					}
				]
			dist_svg:
				files: [
					{
						expand: true
						cwd: 'src/svg/'
						src: ['**/*']
						dest: 'dist/svg/'
					}
				]
			copy_complete_js:
				files:
					"dev/js/complete.js": [".tmp/js/complete.js"]

		uglify:
			dev:
				options:
					compress: false
					beautify: false
					report: true
				files:
					"dev/js/complete.js": [".tmp/js/complete.js"]

			dist:
				options:
					compress: true
				files:
					"dist/js/complete.js": [".tmp/js/complete.js"]

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

		replace:
			socket_config_dev:
				options:
					expression: false
					patterns: [
						{
							match: "ioconfig"
							replacement: "http://192.168.1.3:64156"
						}
						{
							match: "domain"
							replacement: "http://192.168.1.3:8000"
						}
					]

				files:[
					{
						src: [".tmp/js/complete.js"]
						dest: ".tmp/js/complete.js"

					}
				]

			socket_config_dist:
				options:
					expression: false
					patterns: [
						{
							match: "ioconfig"
							replacement: "http://scriptshit.de:64156"
						}
						{
							match: "domain"
							replacement: "http://scriptshit.de/todo"
						}
					]

				files:[
					{
						src: [".tmp/js/complete.js"]
						dest: ".tmp/js/complete.js"

					}
				]

			wp:
				options:
					prefix: ""
					# set some wp mysql details
					patterns: [
						{
							match: "database_name_here"
							replacement: "wp_epago"
						}
						{
							match: "username_here"
							replacement: "root"
						}
						{
							match: "password_here"
							replacement: "root"
						}
					]
				files: [
					{
						src: ['src/wordpress/wp/wp-config-sample.php']
						dest: 'dev_wp/wp-config.php'
					}
				]
		bower_concat:
			all:
				dest: '.tmp/js/libraries.js'
				dependencies:
					'freewall': 'jquery'

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
	grunt.loadNpmTasks 'grunt-replace'
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
		"replace:socket_config_dev",
		"uglify:dev",
		"clean",
		"stylus:dev",
		"copy:fonts",
		"copy:svg",
		"copy:dev_images"
	]
	grunt.registerTask 'build', [
		'concat:coffee',
		'coffee:dist',
		"bower_concat",
		"concat:app",
		"replace:socket_config_dist",
		"uglify:dist",
		"clean",
		"stylus:dist",
		"copy:dist_fonts",
		"copy:dist_images",
		"copy:dist_svg"
	]
