path = require 'path'

module.exports = screens = (grunt) ->
  helpers = require('../../../../helpers')(grunt)

  build: (fn) ->
    screens = helpers.config 'screens'
    phonegapPath = helpers.config 'path'
    res = path.join phonegapPath, 'platforms', 'android', 'res'
    bestPortrait = null
    bestLandscape = null

    densities = [ 'ldpi', 'mdpi', 'hdpi', 'xhdpi' ]

    for density of densities
      portrait = screens?.android?[density]
      landscape = screens?.android?[density + 'Land']

      if portrait
        bestPortrait = portrait
        grunt.file.copy portrait, path.join(res, 'drawable-' + density, 'screen.png'), encoding: null

      if landscape
        bestLandscape = landscape
        grunt.file.copy landscape, path.join(res, 'drawable-land-' + density, 'screen.png'), encoding: null

    if bestPortrait
      grunt.file.copy bestPortrait, path.join(res, 'drawable', 'screen.png'), encoding: null

    if bestLandscape
      grunt.file.copy bestLandscape, path.join(res, 'drawable-land', 'screen.png'), encoding: null

    if fn then fn()
