define ["backbone",
        "jquery",
        "models/moments_collection",
        "views/moments_collection_view"], (Backbone, $, MomentCollection, MomentCollectionView) ->
  App = Backbone.View.extend(
    initialize: ->
      view = new MomentCollectionView()
      $('.container').append(view.el)
  )
  App
