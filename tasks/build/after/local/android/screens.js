(function() {
  var path, screens;

  path = require('path');

  module.exports = screens = function(grunt) {
    var helpers;
    helpers = require('../../../../helpers')(grunt);
    return {
      build: function(fn) {
        var bestLandscape, bestPortrait, densities, density, landscape, phonegapPath, portrait, res, _ref, _ref1;
        screens = helpers.config('screens');
        phonegapPath = helpers.config('path');
        res = path.join(phonegapPath, 'platforms', 'android', 'res');
        bestPortrait = null;
        bestLandscape = null;
        densities = ['ldpi', 'mdpi', 'hdpi', 'xhdpi'];
        for (density in densities) {
          portrait = screens != null ? (_ref = screens.android) != null ? _ref[density] : void 0 : void 0;
          landscape = screens != null ? (_ref1 = screens.android) != null ? _ref1[density + 'Land'] : void 0 : void 0;
          if (portrait) {
            bestPortrait = portrait;
            grunt.file.copy(portrait, path.join(res, 'drawable-' + density, 'screen.png'), {
              encoding: null
            });
          }
          if (landscape) {
            bestLandscape = landscape;
            grunt.file.copy(landscape, path.join(res, 'drawable-land-' + density, 'screen.png'), {
              encoding: null
            });
          }
        }
        if (bestPortrait) {
          grunt.file.copy(bestPortrait, path.join(res, 'drawable', 'screen.png'), {
            encoding: null
          });
        }
        if (bestLandscape) {
          grunt.file.copy(bestLandscape, path.join(res, 'drawable-land', 'screen.png'), {
            encoding: null
          });
        }
        if (fn) {
          return fn();
        }
      }
    };
  };

}).call(this);
