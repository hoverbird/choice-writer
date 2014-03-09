define ["backbone",
        "jquery",
        "views/moments_collection_view"], (Backbone, $, MomentsCollectionView) ->
  App = Backbone.View.extend(
    initialize: ->
      momentsCollection = new MomentsCollectionView(el: $("<div class='moments-collection'>")).render()
      document.body.appendChild momentsCollection.el
  )
  App
