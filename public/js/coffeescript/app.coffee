define [
  "backbone"
  "jquery"
  "underscore"
  "util"
  "choice_router"
  "views/side_nav"
  'bootstrap-affix'
], (Backbone, $, _, Util, Router, NavView) ->
  App = Backbone.View.extend(
    initialize: ->
      router = new Router()
      Backbone.history.start()
      new NavView()
      # router.navigate('/home')
      Util.setupNav()
      Util.railsifyBackbone()
  )
  App
