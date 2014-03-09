fs = require 'fs'

isModified = (filepath) ->
  now = new Date()
  modified =  fs.statSync(filepath).mtime
  return (now - modified) < 10000

gruntFunction = (grunt) ->
  pkg: grunt.file.readJSON 'package.json'

  gruntConfig =
    coffee:
      options:
        sourceMap: true
        bare: true
        force: true # needs to be added to the plugin
      all:
        expand: true
        cwd: 'public/js/coffeescript/'
        src: '**/*.coffee'
        dest: 'public/js/generated'
        ext: '.js'
      modified:
        expand: true
        cwd: 'public/js/coffeescript/'
        src: '**/*.coffee'
        dest: 'public/js/generated'
        ext: '.js'
        filter: isModified

    watch:
      files: ['public/js/coffeescript/**/*.coffee']
      tasks: ["coffee"]


  grunt.initConfig gruntConfig

  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-watch'

  grunt.registerTask 'default', 'coffee'
  grunt.registerTask 'c', 'coffee'

  null

module.exports = gruntFunction
