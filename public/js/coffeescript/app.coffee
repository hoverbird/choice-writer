define ["backbone",
        "jquery",
        "underscore"
        # "jsplumb",
        "util",
        "choice_router",
        "views/side_nav"], (Backbone, $, _, Util, Router, NavView) ->
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
