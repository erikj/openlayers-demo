all: js html

js: js/map.js
	coffee -c js/map.coffee

watch: js/map.js
	coffee -cw js/map.coffee &


html: index.html
	haml index.haml index.html
