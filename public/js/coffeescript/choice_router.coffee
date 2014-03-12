define ["backbone", "views/moments_collection_view"], (Backbone, MomentCollectionView) ->
  ChoiceRouter = Backbone.Router.extend(
    routes:
      "home": "showHome"
      "location/:id": "showLocation"

    showHome: ->
      console.log "Ya done routed to me."
      view = new MomentCollectionView()
      $('.container').append(view.el)

    defaultRoute: (other) ->
      console.log "Poor Choice. You attempted to reach a nonexistant route: #{other}"
  )
  ChoiceRouter
