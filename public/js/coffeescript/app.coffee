define ["backbone",
        "jquery",
        "models/moments_collection",
        "views/moments_collection_view"], (Backbone, $, MomentCollection, MomentCollectionView) ->
  App = Backbone.View.extend(
    initialize: ->
      view = new MomentCollectionView(
        el: $("<div class='moments-collection'>")
      ).render()
      document.body.appendChild(view.el)
  )
  App
