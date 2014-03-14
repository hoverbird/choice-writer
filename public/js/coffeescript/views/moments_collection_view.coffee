define ["backbone",
        "jquery"
        "underscore",
        "models/moments_collection",
        "views/moment_view",
        "hbs!/templates/moment_chain"], (Backbone, $, _, MomentCollection, MomentView, chainTemplate) ->
  MomentsCollectionView = Backbone.View.extend(
    tagName: 'div'

    className: 'moment-chain'

    initialize: ->
      renderThis =  _.bind(this.render, this)
      @collection = new MomentCollection()
      @collection.bind "change", renderThis
      # Do the initial fetch
      @collection.fetch success: renderThis

    render: ->
      chain = $(chainTemplate()) # TODO should the chain template specify this?

      @collection.each (moment) =>
        throw "Shit, son. You missed a moment." unless moment?
        momentElement = new MomentView(model: moment).render().el
        previousMomentID = moment.get("previous_moment_id")
        siblingMoment = chain.find("*[data-previous-moment-id='#{previousMomentID}']")

        if siblingMoment.length
          siblingMoment.parents('.row').after(momentElement)
        else
          chain.append($('<div class="row"></div>').append(momentElement))
      this.$el.html(chain)
      # this.linkNodes()
      this

    linkNodes: ->
      $(".card").each (i, e) ->
        source = $(e)
        if previousMomentId = source.data('previous-moment-id')
          target = $("##{previousMomentId}-Speech-card")
          jsPlumb.connect
            source: source
            target: target
            anchors: [
              [ "Perimeter", shape: "Triangle" ],
              [ "Perimeter", shape: "Diamond" ]
            ]
  )
  MomentsCollectionView
