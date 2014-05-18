define [
  "backbone"
  "jquery"
  "underscore"
  "jsplumb"
  "models/event_response_collection"
  "models/event_response"
  "models/response"
  "views/event_response_view"
  "views/fact_setting_collection"
  "hbs!/templates/event_response_divider"
], (Backbone, $, _, jsPlumb, EventResponseCollection, EventResponse, Response,
    EventResponseView, FactSettingsView, dividerTemplate) ->
  EventResponseCollectionView = Backbone.View.extend(
    tagName: 'div'

    events:
      'click .event-response-divider': 'newEventResponse'

    className: 'event-response-collection'

    initialize: (viewOptions) ->
      Backbone.pubSub.on('selectMoment', this.selectMoment, this)
      @collection = new EventResponseCollection(viewOptions)
      @collection.bind "change", _.bind(this.render, this)
      @collection.fetch success: (data) =>
        @renderFacts.call(this, data)
        @render.call(this, data)

    # Selects another moment in the collection. Options should contain either an
    # id OR an afterId key, depending on whether we know the moment to select or
    # whether it is relative selection (e.g. you want the moment AFTER another)
    selectMoment: (options) ->
      console.log("selectMoment", options)
      momentToSelect = if options.afterId
        @findEventResponseAfter options.afterId
      else if options.id
        @findEventResponse options.id
      else
        throw "You can't select a moment without its ID!"
      console.log("gonna trigger select", momentToSelect[0])
      if momentToSelect.length
        momentToSelect[0].trigger('select')
      else
        # If no moment was found, we create a new one.
        this.newEventResponse previousMomentId: momentToSelect.id

    findEventResponseAfter: (id) ->
      @collection.select (eventResponse) -> eventResponse.get('previous_moment_id') is id

    findEventResponse: (id) -> throw "Unimplemented: findEventResponse"

    newEventResponse: (event) ->
      eventName = $(event.target).data("event-for-new-response")
      er = new EventResponse(name: eventName, folder_id: 3)
      resp = new Response(Type: "SpeechResponse", event_response: er)
      console.log("Coll size before add", @collection.size())
      @collection.add er
      @render()
      # er.trigger 'select'

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
      $('.fact-settings').html(new FactSettingsView(facts).render().el)

    # TODO: this could be refactored to be more efficient, to be sure
    render: ->
      console.log("Coll size on render", @collection.size())
      chain = $('<div></div>')
      @collection.each (eventResponse) =>
        element = new EventResponseView(model: eventResponse).render().el
        chain.append element
        chain.append dividerTemplate(eventForNewResponse: eventResponse.eventForNewResponse())
      this.$el.html(chain)
      # this.linkNodes()
      this

    linkNodes: ->
      @collection.each (eventResponse) ->
        eventName = eventResponse.get('EventName')
        # The target is the element belonging to this eventResponse
        target = $("#event-response-#{eventResponse.get("id")}")[0]
        # The sources are any eventResponses that finish by triggering the event name we listen to
        sources = $("[data-on-finish-event-name='#{eventName}']")
        if target and sources.length
          _(sources).each (source) ->
            jsPlumb.connect
              source: source.parentElement
              target: target.parentElement
              anchors: [
                [ "Perimeter", shape: "Triangle" ],
                [ "Perimeter", shape: "Diamond" ]
              ]

  )
  EventResponseCollectionView
