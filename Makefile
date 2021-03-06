all: application.js worker.js

application.js: src/*.coffee
	browserify -t coffeeify src/application.coffee --debug > application.js || rm application.js

worker.js: src/*.coffee
	browserify -t coffeeify src/worker.coffee --debug > worker.js || rm worker.js

release:
	browserify -t coffeeify src/application.coffee  > application.js || rm application.js
	browserify -t coffeeify src/worker.coffee  > worker.js || rm worker.js

test:
	mocha --require coffeescript/register tests/test*.coffee

test1:
	mocha --require coffeescript/register tests/*native*.coffee


animations.js: src/*.coffee
	browserify -t coffeeify src/animations.coffee --debug > animations.js || rm animations.js


animate-rotation.gif: uploads/animate-rotation-????.png
	echo Making a colormap
	convert +dither -colors 32 -append uploads/animate-rotation-0000.png uploads/animate-rotation-colormap.gif
	echo Convert images to colormap
	mogrify -format gif +dither -map uploads/animate-rotation-colormap.gif uploads/animate-rotation-????.png
	echo Collect GIF
	gifsicle --delay=5 --loopcount=0 -O3 uploads/animate-rotation-????.gif > animate-rotation.gif
	echo Cleanup
	rm uploads/animate-rotation-colormap.gif
	rm uploads/animate-rotation-????.gif

animate-toppler.gif: uploads/animate-toppler-????.png
	echo Making a colormap
	convert +dither -colors 32 -append uploads/animate-toppler-0000.png uploads/animate-toppler-colormap.gif
	echo Convert images to colormap
	mogrify -format gif +dither -map uploads/animate-toppler-colormap.gif uploads/animate-toppler-????.png
	echo Collect GIF
	gifsicle --delay=3 --loopcount=0 -O3 uploads/animate-toppler-????.gif > animate-toppler.gif
	echo Cleanup
	rm uploads/animate-toppler-colormap.gif
	echo rm uploads/animate-toppler-????.gif



animate-grid.gif: uploads/animate-grid-????.png
	echo Making a colormap
	convert +dither -colors 32 -append uploads/animate-grid-0050.png uploads/animate-grid-colormap.gif
	echo Convert images to colormap
	mogrify -format gif +dither -map uploads/animate-grid-colormap.gif uploads/animate-grid-????.png
	echo Collect GIF
	gifsicle --delay=5 --loopcount=0 -O3 uploads/animate-grid-????.gif > animate-grid.gif
	echo Cleanup
	rm uploads/animate-grid-colormap.gif
	rm uploads/animate-grid-????.gif

publish: test release
	git checkout master
	sh deploy.sh

serve: all
	python -m http.server --bind 127.0.0.1 8000 
serveall: all
	python -m http.server
serve-upload: animations.js
	python http_server_with_upload.py

