define ["backbone", "views/moments_collection_view", "views/locations_view"], (Backbone, MomentCollectionView, LocationsView) ->
  ChoiceRouter = Backbone.Router.extend(
    routes:
      "home": "showMoments"
      "locations/:id": "showMomentsByLocation"
      # "locations": "showLocations"

    showMomentsByLocation: (id) ->
      view = new MomentCollectionView constraints: {location: id}
      $('.container').append(view.el)

    showLocations: ->
      view = new LocationsView()
      $('.container').append(view.el)

    defaultRoute: (other) ->
      console.log "Poor Choice. You attempted to reach a nonexistant route: #{other}"

  )
  ChoiceRouter
