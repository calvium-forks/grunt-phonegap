async = require 'async'
path = require 'path'
grunt = require 'grunt'
helpers = require '../../helpers'

remote = (platform, fn) ->
  grunt.task.run 'phonegap:login'
  helpers.exec "phonegap remote build #{platform} #{helpers.setVerbosity()}", fn
  grunt.task.run 'phonegap:logout'

local = (platform, fn) ->
  helpers.exec "phonegap local build #{platform} #{helpers.setVerbosity()}", fn

runAfter = (provider, platform, fn) ->
  adapter = path.join __dirname, '..', 'after', provider, "#{platform}.js"
  if grunt.file.exists adapter
    require(adapter).run(fn)
  else
    grunt.log.writeln "No post-build tasks at '#{adapter}'"
    if fn then fn()

buildPlatform = (platform, fn) ->
  if helpers.isRemote()
    remote platform, ->
      runAfter 'remote', platform, fn
  else
    local platform, ->
      runAfter 'local', platform, fn

module.exports =

  build: (platforms, fn) ->
    grunt.log.writeln 'Building platforms'
    async.eachSeries platforms, buildPlatform, (err) ->
      if fn then fn err