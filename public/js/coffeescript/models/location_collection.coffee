define ["underscore", "backbone", "models/location"], (_, Backbone, Location) ->
  LocationsCollection = Backbone.Collection.extend(
    model: Location
    url: '/locations.json'
  )
  LocationsCollection
