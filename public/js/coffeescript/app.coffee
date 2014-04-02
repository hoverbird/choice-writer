define ["backbone"
        "jquery"
        "underscore"
        "util"
        # "barleyConfig"
        "jsplumb"
        "choice_router",
        "views/side_nav"], (Backbone, $, _, Util, jsplumb, Router, NavView) ->
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
