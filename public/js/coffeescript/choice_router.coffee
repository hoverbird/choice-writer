define ["backbone", "views/moments_collection_view", "views/locations_view"], (Backbone, MomentCollectionView, LocationsView) ->
  ChoiceRouter = Backbone.Router.extend(
    contentContainer: $(".left-col")

    routes:
      "": "showResponses"
      "home": "showResponses"
      "responses/by_tag/:tag": "showRepsonsesByTag"
      "responses/by_folder/:folder_id": "showResponsesByFolder"

    showResponsesByTag: (tag) ->
      view = new MomentCollectionView constraints: { tag: tag }
      @contentContainer.html(view.el)

    showResponsesByFolder: (folder_id) ->
      console.log("foldah")
      view = new MomentCollectionView constraints: { folder_id: folder_id }
      @contentContainer.html(view.el)

    showResponses: (id) ->
      view = new MomentCollectionView()
      @contentContainer.html(view.el)

    defaultRoute: (other) ->
      console.log "Poor Choice. You attempted to reach a nonexistant route: #{other}"

  )
  ChoiceRouter
