define ["underscore", "backbone", "models/location"], (_, Backbone, Location) ->
  MomentsCollection = Backbone.Collection.extend(
    model: Location
    url: '/locations.json'
  )
  LocationsCollection
