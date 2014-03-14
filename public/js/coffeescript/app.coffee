define ["backbone",
        "jquery",
        "jsplumb",
        "util",
        "choice_router"], (Backbone, $, jsPlumb, Util, Router) ->
  App = Backbone.View.extend(
    initialize: ->
      router = new Router()
      Backbone.history.start()
      router.navigate('/home')
      Util.setupNav()
      Util.railsifyBackbone()
  )
  App
