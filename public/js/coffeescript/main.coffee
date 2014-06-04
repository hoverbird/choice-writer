require.config
  paths:
    # tries to load jQuery from Google's CDN first and falls back to load locally
    jquery: [
      "http://ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min"
      "../lib/jquery/dist/jquery.min"
    ]
    underscore: "../lib/underscore/underscore"
    backbone: "../lib/backbone/backbone"
    hbs: '../lib/require-handlebars-plugin/hbs'
    jsplumb: '../lib/jsPlumb/dist/js/jquery.jsPlumb-1.5.5'
    'd3': [
      "http://d3js.org/d3.v3.min"
      '../lib/d3.v3.min'
    ]
    'dagreD3': '../lib/dagre-d3'
    'backbone-relational' : '../lib/backbone-relational/backbone-relational'
    'bootstrap-dropdown': '../lib/bootstrap/js/dropdown'
    'bootstrap-affix': '../lib/bootstrap/js/affix'

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
      exports: "Backbone" # custom export name, this would be lowercase otherwise

    'backbone-relational':
      deps: ['backbone']
    'bootstrap-affix':
      deps: ['jquery']
    'bootstrap-dropdown':
      deps: ['jquery']
    jsplumb:
      deps: ['jquery']
    'dagreD3':
      exports: 'dagreD3'

  # how long the it tries to load a script before giving up, the default is 7
  waitSeconds: 6

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
