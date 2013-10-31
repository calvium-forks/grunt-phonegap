# grunt-phonegap

> Local build tasks for [Phonegap](http://phonegap.com/) applications

`grunt-phonegap` integrates Phonegap development with [Grunt](http://gruntjs.com/)-based workflows
by wrapping the Phonegap 3.0 command line interface.

Rather than polluting the top-level of your project, `grunt-phonegap` copies your files into a
subdirectory containing the Phonegap project, which gets regenerated every build.

## Requirements

You will need the `phonegap` CLI tool installed globally to use `grunt-phonegap`.

```shell
npm install phonegap -g
```
You should also install whatever system dependencies are required by the platforms
you intend to target.

For help with that, see [Platform Guides](http://docs.phonegap.com/en/3.1.0/guide_platforms_index.md.html#Platform%20Guides) from the Phonegap documentation.

## Getting Started
This plugin requires Grunt `~0.4.1`

If you haven't used [Grunt](http://gruntjs.com/) before, be sure to check out the [Getting Started](http://gruntjs.com/getting-started) guide, as it explains how to create a [Gruntfile](http://gruntjs.com/sample-gruntfile) as well as install and use Grunt plugins. Once you're familiar with that process, you may install this plugin with this command:

```shell
npm install grunt-phonegap --save-dev
```

Once the plugin has been installed, it may be enabled inside your Gruntfile with this line of JavaScript:

```js
grunt.loadNpmTasks('grunt-phonegap');
```

### Overview
In your project's Gruntfile, add a section named `phonegap` to the data object passed into `grunt.initConfig()`.

Point `phonegap.config.root` to the output of your other build steps (where your `index.html` file is located).

Point `phonegap.config.config` to your [config.xml](http://docs.phonegap.com/en/3.0.0/config_ref_index.md.html) file.

`phonegap.config.cordova` should be the `.cordova` directory that is generated by `phonegap create`. It must
contain a `config.json` file or your app cannot be built.

### Options

```js
grunt.initConfig({
  phonegap: {
    config: {
      root: 'www',
      config: 'www/config.xml',
      cordova: '.cordova',
      path: 'phonegap',
      plugins: ['/local/path/to/plugin', 'http://example.com/path/to/plugin.git'],
      platforms: ['android'],
      verbose: false,
      releases: 'releases',
      releaseName: function(){
        var pkg = grunt.file.readJSON('package.json');
        return(pkg.name + '-' + pkg.version);
      },

      // Add a key if you plan to use the `release:android` task
      // See http://developer.android.com/tools/publishing/app-signing.html
      key: {
        store: 'release.keystore',
        alias: 'release',
        aliasPassword: function(){
          // Prompt, read an environment variable, or just embed as a string literal
          return('');
        },
        storePassword: function(){
          // Prompt, read an environment variable, or just embed as a string literal
          return('');
        }
      }
    }
  }
})
```

### Tasks

#### phonegap:build

Running `phonegap:build` with no arguments will...

* Purge your `phonegap.config.path`
* Copy your `phonegap.config.cordova` and `phonegap.config.root` files into it
* Add any plugins listed in `phonegap.config.plugins`
* ..and then generate a Phonegap build for all platforms listed in `phonegap.config.platforms`

##### Dynamic config.xml

Beginning with **v0.4.1**, `phonegap.config.config` may be either a string or an object.

As a string, the file is copied directly, as with previous versions.

As an object with the keys `template<String>` and `data<Object>`, the file at `template` will
be processed using [grunt.template](http://gruntjs.com/api/grunt.template).

###### Example

**Gruntfile.js**


```js
  // ...
  phonegap: {
    config: {
      config: {
        template: '_myConfig.xml',
        data: {
          id: 'com.grunt-phonegap.example'
          version: grunt.pkg.version
          name: grunt.pkg.name
        }
      }
  // ...
```

**_myConfig.xml**

```xml
<?xml version='1.0' encoding='utf-8'?>
<widget id="<%= id %>" version="<%= version %>" xmlns="http://www.w3.org/ns/widgets" xmlns:gap="http://phonegap.com/ns/1.0">
    <name><%= name %></name>
    <!-- ... -->
</widget>

```

#### phonegap:run[:platform][:device]

After a build is complete, the `phonegap:run` grunt task can be used to launch your app
on an emulator or hardware device. It accepts two optional arguments, `platform` and `device`.

Example: `grunt phonegap:run:android:emulator`

If you are using the Android platform, you can see the list of connected devices by running `adb devices`.

The platform argument will default to the first platform listed in `phonegap.config.platforms`.

#### phonegap:release[:platform]

Create a releases/ directory containing a signed application package for distribution.

Currently `android` is the only platform supported by this task. You will need to create
a keystore file at `phonegap.config.key.store` like this:

    $ keytool -genkey -v -keystore release.keystore -alias release -keyalg RSA -keysize 2048 -validity 10000

The keytool command will interactively ask you to set store and alias passwords, which must match
the return value of `phonegap.config.key.aliasPassword` and `phonegap.config.key.storePassword` respectively.

## What's next

* `release` task for iOS and other platforms
* Set an app icon during build task

## Running the test suite

    git clone https://github.com/logankoester/grunt-phonegap.git
    cd grunt-phonegap
    npm install
    git submodule init
    git submodule update
    grunt

## Contributing

Fork the repo on Github and open a pull request. Note that the files in `tasks/` and `test/` are the output of
CoffeeScript files in `src/`, and will be overwritten if edited by hand.

Before running the included test suite, you must first run `git submodule update` on your local clone (see above).

## Release History

#### 0.4.0
  * Adds `release:android` task to build a releases/ directory containing a signed APK for distribution.
  * Includes compiled tasks/ directory in source countrol
  * Removes `phonegap` npm dependency - install it globally with -g instead.

#### 0.3.0

  * Fixes [issue #2](https://github.com/logankoester/grunt-phonegap/issues/2) "Test not completing" (thanks @skarjalainen and @jrvidal)
  * Removed default 'device' flag (thanks @robwalch)

#### 0.2.0

  * Adds 'config' option for specifying a custom path to 'config.xml'.

#### 0.1.0

  * Initial release

## License

Copyright (c) 2013 Logan Koester.
Released under the MIT license. See `LICENSE-MIT` for details.


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/logankoester/grunt-phonegap/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

