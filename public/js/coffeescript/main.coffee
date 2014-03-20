require.config
  paths:
    # tries to load jQuery from Google's CDN first and falls back to load locally
    jquery: [
      "http://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min"
      "../lib/jquery/jquery"
    ]
    underscore: "../lib/underscore/underscore"
    backbone: "../lib/backbone/backbone"
    hbs: '../lib/require-handlebars-plugin/hbs'
    jsplumb: '../lib/jsPlumb/dist/js/jquery.jsPlumb-1.5.5'
    # 'backbone.keys': '../lib/backbone.keys/dist/backbone.keys.min'
    # jasmine: '../lib/jasmine-jquery/lib/jasmine-jquery'
    # 'jasmine-html': '../lib/jasmine-jquery/lib/jasmine/lib/jasmine-html'


  hbs:
    helpers: true,                     # default: true
    i18n: false,                       # default: false
    templateExtension: 'handlebars',   # default: 'hbs'
    partialsUrl: '../../templates/partials'     # default: ''

  shim:
    backbone:
      # loads dependencies first
      deps: [
        "jquery"
        "underscore"
      ]
      # custom export name, this would be lowercase otherwise
      exports: "Backbone"

  # how long the it tries to load a script before giving up, the default is 7
  waitSeconds: 10


# requiring the scripts in the first argument and then passing the library namespaces into a callback
# you should be able to console log all of the callback arguments
require [
  "jquery"
  "underscore"
  "backbone"
  "app"
], (jquery, _, Backbone, App) ->
  new App()
  return
