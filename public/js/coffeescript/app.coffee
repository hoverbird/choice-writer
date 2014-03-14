define ["backbone",
        "jquery",
        "jsplumb",
        "choice_router"], (Backbone, $, jsPlumb, Router) ->
  App = Backbone.View.extend(
    initialize: ->
      router = new Router()
      Backbone.history.start()
      router.navigate('/home')

      $('ul.nav').on("click", "a:not([data-bypass])", (evt) ->
        href =
          prop: $(this).prop("href")
          attr: $(this).attr("href")
        root = "#{location.protocol}//#{location.host}/"
        if href.prop and href.prop.slice(0, root.length) == root
          evt.preventDefault()
          Backbone.history.navigate(href.attr, true)
      )
  )
  App
