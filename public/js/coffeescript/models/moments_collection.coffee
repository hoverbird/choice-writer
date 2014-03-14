define ["underscore", "backbone", "models/moment"], (_, Backbone, Moment) ->
  MomentsCollection = Backbone.Collection.extend(
    model: Moment
    url: '/moments.json'
  )
  MomentsCollection
