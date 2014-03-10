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
      @collection = new MomentCollection()
      @collection.bind "change", _.bind(this.render, this)
      @collection.fetch success: =>
        console.log("moment collection fetched")
        @collection.fetch()

    render: ->
      @collection.each (moment) =>
        throw "Shit, son. No moments" unless moment?
        momentView = new MomentView(model: moment)
        this.$el.append(momentView.render().el)
      this
  )
  MomentsCollectionView
