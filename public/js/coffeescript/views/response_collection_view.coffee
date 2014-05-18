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
      @collection = opts.responses
      this.render()

    render: () ->

      _(@collection).each (response) =>
        responseElement = new ResponseView(model: response).render()
        this.$el.append responseElement.el
      this
  )
  ResponseCollectionView
