define ["backbone",
        "jquery",
        "jsplumb",
        "choice_router"], (Backbone, $, jsPlumb, Router) ->
  App = Backbone.View.extend(
    initialize: ->
      router = new Router()
      Backbone.history.start()
      router.navigate('/home')
  )
  App
