define [
  "backbone"
  "jquery"
  "underscore"
  "models/moments_collection"
  "models/moment"
  "views/moment_view"
  "views/fact"
  "hbs!/templates/moment_chain"
], (Backbone, $, _, MomentCollection, Moment, MomentView, FactView, chainTemplate) ->
  MomentsCollectionView = Backbone.View.extend(
    tagName: 'div'

    className: 'moment-chain'

    initialize: (viewOptions) ->
      Backbone.pubSub.on('selectMoment', this.selectMoment, this)
      renderThis =  _.bind(this.render, this)
      @collection = new MomentCollection(viewOptions)
      @collection.bind "change", renderThis
      @collection.fetch success: (data) =>
        @renderFacts.call(this, data)
        @render.call(this, data)

    # Selects another moment in the collection. Options should contain either an
    # id OR an afterId key, depending on whether we know the moment to select or
    # whether it is relative selection (e.g. you want the moment AFTER another)
    selectMoment: (options) ->
      console.log("selectMoment", options)
      momentToSelect = if options.afterId
        @findMomentAfter options.afterId
      else if options.id
        @findMoment options.id
      else
        throw "You can't select a moment without its ID!"
      console.log("gonna trigger select", momentToSelect[0])
      if momentToSelect.length
        momentToSelect[0].trigger('select')
      else
        # If no moment was found, we create a new one.
        this.newMoment previousMomentId: momentToSelect.id

    findMomentAfter: (momentId) ->
      @collection.select (moment) -> moment.get('previous_moment_id') is momentId

    newMoment: (options) ->
      moment = new Moment(previous_moment_id: options.previousMomentId)
      @collection.add moment
      @render()
      moment.trigger 'select'

    # gather a hash of facts and default values as referenced in all reqs and resps
    # in the collection. we should probably do this on the server.
    renderFacts: (collection) ->
      facts = {}
      _(collection.models).each (er) ->
        if responses = er.get("Responses")
          _(responses.models).each (resp) ->
            if resp and resp.get("Type") is "FactResponse"
              # console.log "FactResponse", resp
              facts[resp.get("Name")] = resp.get("DefaultStatus")
        if requirements = er.get("Requirements")
          _(requirements).each (req) ->
            # console.log("req", req)
            facts[req.name] = req.DefaultStatus



    render: ->
      chain = $(chainTemplate()) # TODO should the chain template specify this?
      @collection.each (moment) =>

        momentElement = new MomentView(model: moment).render().el
        chain.append momentElement
        # previousMomentID = moment.get("previous_moment_id")
        # siblingMoment = chain.find("*[data-previous-moment-id='#{previousMomentID}']")
        #
        # if siblingMoment.length
        #   siblingMoment.parents('.row').after(momentElement)
        # else
        #   chain.append($('<div class="row"></div>').append(momentElement))
      this.$el.html(chain)
      # this.linkNodes()
      # window.barley.editor.init()
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
