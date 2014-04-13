define ["backbone"
        "jquery"
        "underscore"
        "models/response_collection"
        "views/response_view"], (Backbone, $, _, ResponseCollection, ResponseView) ->
  ResponseCollectionView = Backbone.View.extend(
    tagName: 'ul'

    className: 'response-collection'

    initialize: (opts) ->
      return unless opts and opts.responses
      console.log("initting the response_collection VIEW", opts)
      @collection = opts.responses
      this.render()

    render: () ->
      _(@collection).each (response) =>
        console.log "appending", response
        responseElement = new ResponseView(model: response).render().el
        this.$el.append responseElement
  )
  ResponseCollectionView
