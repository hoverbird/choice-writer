define ["backbone",
        "jquery",
        "choice_router"], (Backbone, $, Router) ->
  App = Backbone.View.extend(
    initialize: ->
      router = new Router()
      Backbone.history.start()
      router.navigate('/home')
  )
  App
