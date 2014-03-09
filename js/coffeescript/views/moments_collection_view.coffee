define ["backbone", "underscore", "views/moment_view", "models/moments_collection"], (Backbone, _, MomentView, MomentCollection) ->
  MomentsCollectionView = Backbone.View.extend(
    tagName: 'div'

    className: 'moments-collection'

    initialize: ->
      @collection = new MomentCollection();
      @collection.bind "change", _.bind(this.render, this)
      @collection.fetch success: ->
        console.log("moment collection fetched")
        debugger

    render: ->
      debugger
      _.each @collection, (moment) =>
        console.log "a moment", moment
        momentView = new MomentView(model: moment)
        this.$el.append(momentView.render().el)
      this
  )
  MomentsCollectionView
