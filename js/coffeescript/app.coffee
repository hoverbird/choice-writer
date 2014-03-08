define ["backbone", "models/moment", "views/momentview"], (Backbone, Moment, MomentView) ->
  App = Backbone.View.extend(
    initialize: ->
      moment = new Moment()
      view = new MomentView(model: moment)
      view.render()
      document.body.appendChild view.el
  )
  App
