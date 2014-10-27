fs = require('fs')
path = require('path')
bower_json = require('bower-json')
coffee = require('coffee-script')

walk = (dir, done) ->
	results = []
	fs.readdir dir, (err, list) ->
		return done(err) if err
		pending = list.length
		return done(null, results) unless pending
		list.forEach (file) ->
			file = dir + "/" + file
			fs.stat file, (err, stat) ->
				if stat and stat.isDirectory()
					walk file, (err, res) ->
						results = results.concat(res)
						done null, results	unless --pending

				else
					if file.substr(-6) == "coffee"
						results.push file
					done null, results	unless --pending

concatApp = (libFile)->
	app = ''
	app = app+fs.readFileSync(path.resolve('./coffee/bootstrap.coffee'),{encoding: 'utf8'})
	walk path.resolve("./coffee/modules"), (err, result)->
		result.forEach (dir)->
			app = app+'\n'+fs.readFileSync(path.resolve(dir),{encoding: 'utf8'})

		app = app+'\n'+fs.readFileSync(path.resolve('./coffee/main.coffee'),{encoding: 'utf8'})

		# write app
		if !fs.existsSync(path.resolve("./_js/"))
			fs.mkdirSync(path.resolve("./_js/"))

		app = coffee.compile(app)
		fs.writeFileSync(path.resolve('./_js/complete.js'), libFile+app)

concatBower = ()->
	pkgs = []
	libFile = ''
	componentsDirClean = []
	componentsDir = fs.readdirSync('./bower_components')
	componentsDir.forEach (dir)->
		if dir[0] != '.'
			componentsDirClean.push dir

	i = 1
	componentsDirClean.forEach (dir)->
		data = false
		component = path.resolve('./bower_components/' + dir)
		if fs.existsSync(component+'/bower.json')
			component = component+'/bower.json'

		if fs.existsSync(component+'/.bower.json')
			component = component+'/.bower.json'

		bower_json.read component, (err, file)->
			libpath = path.resolve('./bower_components/' + dir+'/'+file.main)
			libFile = libFile+'\n\n'+fs.readFileSync(libpath, {encoding: 'utf8'})
			if componentsDirClean.length != i
				i++
			else
				# write libfile
				if !fs.existsSync(path.resolve("./_js/"))
					fs.mkdirSync(path.resolve("./_js/"))

				concatApp(libFile)

# sorry, but just a dirty dirty hack to concat all coffee files
module.exports = concatBower



