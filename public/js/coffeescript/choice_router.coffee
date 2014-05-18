define [
  "backbone"
  "views/event_response_collection_view"
], (Backbone, EventResponseCollectionView) ->
  ChoiceRouter = Backbone.Router.extend(
    contentContainer: $(".left-col")

    routes:
      "": "showResponses"
      "home": "showResponses"
      "response/:id": "responsePermalink"
      "responses/by_tag/:tag": "showRepsonsesByTag"
      "responses/by_folder/:folder_id": "showResponsesByFolder"
      "search": "search"

    showResponsesByTag: (tag) ->
      view = new EventResponseCollectionView constraints: { tag: tag }
      @contentContainer.html(view.el)

    showResponsesByFolder: (folder_id) ->
      view = new EventResponseCollectionView constraints: { folder_id: folder_id }
      @contentContainer.html(view.el)

    showResponses: (id) ->
      view = new EventResponseCollectionView()
      @contentContainer.html(view.el)

    responsePermalink: (id) ->
      console.log "RESP PERM", id
      view = new EventResponseCollectionView constraints: { permalinkId: id }
      @contentContainer.html(view.el)

    search: (queryString) ->
      view = new EventResponseCollectionView constraints: { searchQuery: queryString }
      @contentContainer.html(view.el)

    defaultRoute: (other) ->
      console.log "Poor Choice. You attempted to reach a nonexistant route: #{other}"

  )
  ChoiceRouter
