define ["backbone",
        "jquery",
        "models/moments_collection",
        "views/moments_collection_view"], (Backbone, $, MomentCollection, MomentCollectionView) ->
  App = Backbone.View.extend(
    initialize: ->
      momentsCollection = new MomentCollection()
      debugger
      momentsCollection.get(1)
      view = new MomentCollectionView(
        el: $("<div class='moments-collection'>")
        collection: momentsCollection
      ).render()
      document.body.appendChild(view.el)
  )
  App
