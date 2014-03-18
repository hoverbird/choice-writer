define ["backbone", "views/moments_collection_view", "views/locations_view"], (Backbone, MomentCollectionView, LocationsView) ->
  ChoiceRouter = Backbone.Router.extend(
    contentContainer: $(".left-col")

    routes:
      "#": "showMoments"
      "locations/:id": "showMomentsByLocation"
      "moments/by_tag/:tag": "showMomentsByTag"

    showMomentsByLocation: (id) ->
      view = new MomentCollectionView constraints: {location: id}
      @contentContainer.html(view.el)

    showMomentsByTag: (tag) ->
      view = new MomentCollectionView constraints: {tag: tag}
      @contentContainer.html(view.el)

    showMoments: (id) ->
      view = new MomentCollectionView()
      @contentContainer.html(view.el)

    defaultRoute: (other) ->
      console.log "Poor Choice. You attempted to reach a nonexistant route: #{other}"

  )
  ChoiceRouter
