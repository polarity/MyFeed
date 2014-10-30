# watches the file input and uses the name
# attribute to server a file blob to 
# scope.currentItem[ attr.name ]
Directive = ($timeout)->

	restrict: 'E'

	replace: true

	template: '<div><input type="file"></input></div>'

	scope: { bgimgurl: '&'}

	link: (scope, element, attr) ->
		element.bind 'change', (event)->

			# resize
			# returns a file blob. prepared
			resize = (dataUri, callback)->
				canvas = document.createElement('canvas')
				ctx = canvas.getContext('2d')
				image = new Image()
				image.src = dataUri
				MAX_HEIGHT = 200
				image.onload = ()->
					if(image.height > MAX_HEIGHT)
						image.width *= MAX_HEIGHT / image.height
						image.height = MAX_HEIGHT

					canvas.width = image.width
					canvas.height = image.height
					ctx.drawImage(image, 0,0, image.width, image.height)

					# only firefox can do this
					if typeof document.createElement('canvas').toBlob != 'undefined'
						blobReady = (blob)-> callback(blob)
						canvas.toBlob(blobReady, "image/jpeg")

					# chrome/webkit implementation
					if typeof document.createElement('canvas').toBlob == 'undefined'
						# Creates and returns a blob from a data URL (either base64 encoded or not).
						# @param {string} dataURL The data URL to convert.
						# @return {Blob} A blob representing the array buffer data.
						dataURLToBlob = (dataURL) ->
							BASE64_MARKER = ";base64,"
							if dataURL.indexOf(BASE64_MARKER) is -1
								parts = dataURL.split(",")
								contentType = parts[0].split(":")[1]
								raw = decodeURIComponent(parts[1])
								return new Blob([raw],
									type: contentType
								)
							parts = dataURL.split(BASE64_MARKER)
							contentType = parts[0].split(":")[1]
							raw = window.atob(parts[1])
							rawLength = raw.length
							uInt8Array = new Uint8Array(rawLength)
							i = 0
							while i < rawLength
								uInt8Array[i] = raw.charCodeAt(i)
								++i
							new Blob([uInt8Array],
								type: contentType
							)
						# get blob from a DataURL
						blob = dataURLToBlob(canvas.toDataURL("image/jpeg"))
						# and call our callback
						callback(blob)

			# read file from the file input
			filereader = new FileReader()
			filereader.onload = ()->
				# is the file data loaded, resize the file
				resize filereader.result, (resizedFile) ->
					# get the resized filereader object back
					# and stuff it into the scope property
					canvas = document.createElement('canvas')
					img = new Image
					img.src = URL.createObjectURL(resizedFile)
					img.onload = ()-> 
						stackBlurImage( img, canvas, 20)
						$('.Background').css({'background-image': 'url("'+canvas.toDataURL("image/jpeg",0.8)+'")'})
						scope.bgimgurl({datauri: canvas.toDataURL("image/jpeg")})

			# read from blob and return a DataURL
			filereader.readAsDataURL(event.target.files[0])

			
# Angular Foo
# Since Angular infers the controller's dependencies from the 
# names of arguments to the controller's constructor function, 
# if you were to minify the JavaScript code for PhoneListCtrl 
# controller, all of its function arguments would be minified 
# as well, and the dependency injector would not be able to 
# identify services correctly.
# http://docs.angularjs.org/tutorial/step_05
Directive.$inject = ['$timeout']
window.app.directive 'imgUpload', Directive