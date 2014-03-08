define ["backbone", 'models/moment'], (Backbone, Moment) ->
  App = Backbone.View.extend(
    initialize: ->
      moment = new Moment
      console.log "it's working!??!???^", moment.toJSON()
  )
  App
