define ["backbone", "views/moments_collection_view", "views/locations_view"], (Backbone, MomentCollectionView, LocationsView) ->
  ChoiceRouter = Backbone.Router.extend(
    routes:
      "home": "showHome"
      "location/:id": "showLocation"
      "locations": "showLocations"

    showHome: ->
      view = new MomentCollectionView()
      $('.container').append(view.el)

    showLocations: ->
      view = new LocationsView()
      $('.container').append(view.el)

    defaultRoute: (other) ->
      console.log "Poor Choice. You attempted to reach a nonexistant route: #{other}"


  )
  ChoiceRouter
