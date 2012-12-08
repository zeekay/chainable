exec = require 'executive'

task 'build', 'build project', ->
  exec './node_modules/.bin/coffee -b -c -o lib/ src/'

task 'watch', 'rebuild project on changes', (options) ->
  exec './node_modules/.bin/coffee -b -w -c -o lib/ src/'

task 'test', 'run tests', ->
  exec './node_modules/.bin/mocha --compilers coffee:coffee-script -R spec -t 5000 -c test/'

task 'publish', 'publish current version to github & npm', ->
  exec '''
  ./node_modules/.bin/coffee -b -c -o lib/ src/
  git push
  npm publish
  '''.split '\n'
