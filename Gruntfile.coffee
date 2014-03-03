# module.exports = (grunt) ->
#   grunt.initConfig(
#     pkg: grunt.file.readJSON('package.json')
#     concat:
#       options:
#         separator: ';'
#       dist:
#         src: ['src/**/*.js']
#         dest: 'dist/<%= pkg.name %>.js'
#   )
#   grunt.registerTask 'default', 'coffee watch'

gruntFunction = (grunt) ->
  gruntConfig =
    coffee:
      glob_to_multiple:
        expand: true
        flatten: true
        cwd: 'js/coffeescript'
        src: ['*.coffee']
        dest: 'js/generated'
        ext: '.js'

    watch:
      files: ['js/coffeescript/*.coffee']
      tasks: ["coffee"]

    coffeelint:
      app: ['js/coffeescript/*.coffee']
      max_line_length:
        level: "ignore"
    #   app:
    #     src: "<config:coffee.app.src>"
    #     indentation:
    #       value: 2
    #       level: "warn"
    #     no_trailing_whitespace:
    #       level: "error"
    #     no_trailing_semicolons:
    #       level: "error"
    #     no_plusplus:
    #       level: "warn"
    #     no_implicit_parens:
    #       level: "ignore"
    #     max_line_length:
    #       level: "ignore"
    #   testjs:
    #     src: "<config:coffee.testjs.src>"
    #     indentation:
    #       value: 2
    #       level: "warn"
    #     no_trailing_whitespace:
    #       level: "error"
    #     no_trailing_semicolons:
    #       level: "error"
    #     no_plusplus:
    #       level: "warn"
    #     no_implicit_parens:
    #       level: "ignore"
    #     max_line_length:
    #       level: "ignore"

  grunt.initConfig gruntConfig

  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-coffeelint'

  grunt.registerTask 'default', 'coffee'
  grunt.registerTask 'c', 'coffee'
  grunt.registerTask 'lint', 'coffeelint'

  null

#debug : call with a dummy 'grunt', that spits params on console.log
#gruntFunction
# initConfig: (cfg)-> console.log 'grunt: initConfig\n', JSON.stringify cfg, null, ' '
# loadNpmTasks: (tsk)-> console.log 'grunt: registerTask: ', tsk
# registerTask: (shortCut, task)-> console.log 'grunt: registerTask:', shortCut, task
module.exports = gruntFunction
