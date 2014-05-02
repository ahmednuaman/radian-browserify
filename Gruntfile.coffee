# If you're new to [Grunt](http://gruntjs.com) then get yourself over to the
# ['getting started'](http://gruntjs.com/getting-started) section on their site.
module.exports = (grunt) ->
  # To keep this file as minimal as possible the [NPM](http://npmjs.org) tasks are stored in the `./grunt/` folder as
  # individual files for each task.
  grunt.loadTasks 'grunt'

  # ## grunt githash
  # This task creates a Grunt config variable called `git-commit` that contains the latest git commit sha1 hash.
  grunt.registerTask 'githash', 'grabs the latest git commit hash', () ->
    done = @async()

    config =
      cmd: 'git'
      args: [
        'rev-parse'
        '--verify'
        'HEAD'
      ]

    grunt.util.spawn config, (err, result) ->
      # To deal with cache busting this task grabs the latest git commit sha1 and uses this for naming the optimised
      # CSS and JS files.
      grunt.config 'git-commit', result.stdout
      grunt.log.ok "Setting `git-commit` to #{result.stdout}"

      done()

  # ## grunt default
  # This task is useful for running whilst you're developing your app. It runs the development preprocessor tasks,
  # starts the local express server and watches your files as you code your awesome app.
  grunt.registerTask 'default', 'run the server and watch for changes', [
    'githash'
    'sprite'
    'compass:devSASS'
    # 'compass:devSCSS'
    # 'less:dev'
    # 'stylus:dev'
    'coffee:dev'
    'browserify'
    'jade:dev'
    'express'
    'watch'
  ]

  # ## grunt test
  # This task runs both the unit and e2d tests.
  grunt.registerTask 'test', 'compile the app and run the tests', [
    'githash'
    'sprite'
    'compass:devSASS'
    # 'compass:devSCSS'
    # 'less:dev'
    # 'stylus:dev'
    # 'jshint'
    # 'jscs'
    'coffeelint'
    'coffee:dev'
    'karma'
    'coffee:e2e'
    'browserify'
    'jade:dev'
    'express'
    'exec:e2e'
  ]

  # ## grunt unit
  # This task runs the unit tests in [karma](http://karma-runner.github.io).
  grunt.registerTask 'unit', 'run unit tests', [
    'githash'
    # 'jshint'
    # 'jscs'
    'coffeelint'
    'coffee:dev'
    'browserify'
    'karma'
  ]

  # ## grunt e2e
  # This task runs the e2e tests in [protractor](https://github.com/angular/protractor).
  grunt.registerTask 'e2e', 'run e2e tests', [
    'githash'
    'sprite'
    'compass:devSASS'
    # 'compass:devSCSS'
    # 'less:dev'
    # 'stylus:dev'
    # 'jshint'
    # 'jscs'
    'coffeelint'
    'coffee:dev'
    'coffee:e2e'
    'browserify'
    'jade:dev'
    'express'
    'exec:e2e'
  ]

  # ## grunt build
  # This task builds the app. It starts by running all the preprocessors in production mode, compressing the images
  # and packages up the app using the awesome [`browserify`](http://browserify.org/). It then copies files into place
  # (by default into the `./build/` directory) and replaces the third-party libraries with CDN versions. Finally it
  # executes the crawler to make the app SEO friendly.
  grunt.registerTask 'build', 'build and package the app', [
    'clean'
    'githash'
    'sprite'
    'imagemin'
    'compass:prodSASS'
    # 'compass:prodSCSS'
    # 'less:prod'
    # 'stylus:prod'
    'cmq'
    'cssmin'
    'coffee:prod'
    'jade:prod'
    'ngtemplates'
    'browserify'
    'copy'
    'express'
    'exec:crawl'
    'replace'
  ]
