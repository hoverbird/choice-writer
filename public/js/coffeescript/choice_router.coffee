define [
  "backbone"
  "views/event_response_collection_view"
], (Backbone, EventResponseCollectionView) ->
  ChoiceRouter = Backbone.Router.extend(
    contentContainer: $(".left-col")
    pageTitle: $(".page-title")

    routes:
      "": "showResponses"
      "home": "showResponses"
      "response/:id": "responsePermalink"
      "responds_to_event/:event_name": "showRespondsToEvent"
      "responses/by_folder/:folder_id": "showResponsesByFolder"
      "search": "search"

    showRespondsToEvent: (eventName) ->
      @setPageTitle "#{eventName} responses"
      view = new EventResponseCollectionView constraints: {respondsToEvent: eventName}
      @contentContainer.html(view.el)

    showResponsesByFolder: (folder_id) ->
      view = new EventResponseCollectionView constraints: { folder_id: folder_id }
      @contentContainer.html(view.el)

    showResponses: (id) ->
      view = new EventResponseCollectionView()
      @contentContainer.html(view.el)

    responsePermalink: (id) ->
      view = new EventResponseCollectionView constraints: { permalinkId: id }
      @contentContainer.html(view.el)

    search: (queryString) ->
      @setPageTitle "Searching for #{queryString}"
      view = new EventResponseCollectionView constraints: { searchQuery: queryString }
      @contentContainer.html(view.el)

    setPageTitle: (title) ->
      @pageTitle.html("<h2 class='page-title'>#{title}</h2>") if title

    defaultRoute: (other) ->
      console.log "Poor Choice. You attempted to reach a nonexistant route: #{other}"

  )
  ChoiceRouter
