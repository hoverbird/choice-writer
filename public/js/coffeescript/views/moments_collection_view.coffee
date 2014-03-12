define ["backbone",
        "jquery"
        "underscore",
        "models/moments_collection",
        "views/moment_view",
        "hbs!/templates/moment_chain"], (Backbone, $, _, MomentCollection, MomentView, chainTemplate) ->
  MomentsCollectionView = Backbone.View.extend(
    tagName: 'div'

    className: 'row moment-chain'

    initialize: ->
      renderThis =  _.bind(this.render, this)
      @collection = new MomentCollection()
      @collection.bind "change", renderThis
      # Do the initial fetch
      @collection.fetch success: renderThis

    render: ->
      chain = $(chainTemplate()) # TODO should the chain template specify this iteration?
      @collection.each (moment) =>
        throw "Shit, son. No moments" unless moment?
        momentView = new MomentView(model: moment)
        chain.append(momentView.render().el)
      this.$el.html(chain)
      this
  )
  MomentsCollectionView
