define ["underscore", "backbone"], (_, Backbone) ->
  Moment = Backbone.Model.extend(
    initialize: -> console.log("am I a model?!")
    defaults:
      name: "A moment in time..."
  )
  Moment
