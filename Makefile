all: js html

.PHONY: js html watch

js: | js/map.js

js/map.js: js/map.coffee
	coffee -c js/map.coffee

watch:
	coffee -cw js/map.coffee &

html: | index.html

index.html: index.haml
	haml index.haml index.html
