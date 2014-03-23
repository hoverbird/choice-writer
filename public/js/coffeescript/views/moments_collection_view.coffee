define ["backbone",
        "jquery"
        "underscore",
        "models/moments_collection",
        "views/moment_view",
        "hbs!/templates/moment_chain"], (Backbone, $, _, MomentCollection, MomentView, chainTemplate) ->
  MomentsCollectionView = Backbone.View.extend(
    tagName: 'div'

    className: 'moment-chain'

    initialize: (constraints) ->
      Backbone.pubSub.on('selectNextMoment', this.selectMoment, this) #TODO: wish I could use event bubbling for this...
      renderThis =  _.bind(this.render, this)
      @collection = new MomentCollection(constraints)
      @collection.bind "change", renderThis
      @collection.fetch success: renderThis # Do the initial fetch

    selectMoment: (event) ->
      console.log("selectMoment", event)
      nextMoment = @collection.select (moment) -> moment.get('previous_moment_id') is event.id
      console.log("gonna trigger select", nextMoment[0])
      if nextMoment.length
        nextMoment[0].trigger('select')
      else
        newMoment after: event.id

    newMoment: (options) ->

    render: ->
      chain = $(chainTemplate()) # TODO should the chain template specify this?
      @collection.each (moment) =>
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

    # linkNodes: ->
    #   $(".card").each (i, e) ->
    #     source = $(e)
    #     if previousMomentId = source.data('previous-moment-id')
    #       target = $("##{previousMomentId}-Speech-card")
    #       jsPlumb.connect
    #         source: source
    #         target: target
    #         anchors: [
    #           [ "Perimeter", shape: "Triangle" ],
    #           [ "Perimeter", shape: "Diamond" ]
    #         ]
  )
  MomentsCollectionView
