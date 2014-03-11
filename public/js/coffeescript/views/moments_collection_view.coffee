define ["backbone",
        "underscore",
        "models/moments_collection",
        "views/moment_view",
        "hbs!/templates/moment_chain"], (Backbone, _, MomentCollection, MomentView, chainTemplate) ->
  MomentsCollectionView = Backbone.View.extend(
    tagName: 'div'

    #TODO:  should be "moment-chain"
    className: "#moments"

    initialize: ->
      renderThis =  _.bind(this.render, this)
      @collection = new MomentCollection()
      @collection.bind "change", renderThis
      # Do the initial fetch
      @collection.fetch success: renderThis

    render: ->
      @collection.each (moment) =>
        throw "Shit, son. No moments" unless moment?
        console.log "Oops, a moment", moment.toJSON()
        momentView = new MomentView(model: moment)
        this.$el.append(momentView.render().el)
      this
  )
  MomentsCollectionView
