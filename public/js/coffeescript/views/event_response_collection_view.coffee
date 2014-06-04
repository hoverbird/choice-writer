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
  'bootstrap-dropdown'
  'dagreD3'
], (Backbone, $, _, jsPlumb, EventResponseCollection, EventResponse, Response,
    EventResponseView, FactSettingsView, dividerTemplate) ->
  EventResponseCollectionView = Backbone.View.extend(
    tagName: 'div'

    events:
      'click .event-response-divider': 'newEventResponse'

    className: 'event-response-collection'

    initialize: (viewOptions) ->
      #TODO: remove, this is blunt as fuck
      $(window).resize -> jsPlumb.repaintEverything();

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
      er = new EventResponse(EventName: eventName, folder_id: 3) # TODO: MAKE THIS NOT FAKE
      resp = new Response(Type: "SpeechResponse", event_response: er, text: "Just checked in to see what condition my condition was in")
      console.log("Coll size before add", @collection.size())
      @collection.add er
      @render()
      # er.trigger 'select'

    # Gather a hash of facts and default values as referenced in all reqs and resps
    # in the collection. We should probably do this on the server.
    renderFacts: (collection) ->
      facts = {}
      _(collection.models).each (er) ->
        if responses = er.get("Responses")
          _(responses.models).each (resp) ->
            if resp and resp.get("Type") is "FactResponse"
              facts[resp.get("Name")] = resp.get("DefaultStatus")
        if requirements = er.get("Requirements")
          _(requirements).each (req) ->
            facts[req.Name] = req.DefaultStatus
      $('.fact-settings-container').html(new FactSettingsView(facts).render().el)

    render: ->
      svg = $("<svg width='100%' height='100%'>
          <g transform='translate(20,20)'/>
      </svg>
      ")
      this.$el.append svg
      graph = new dagreD3.Digraph()
      @collection.each (eventResponse) =>
        console.log "Adding", eventResponse.attributes
        view = new EventResponseView(model: eventResponse).render()
        graph.addNode(eventResponse.get('id'), label: view.htmlString)
      @collection.each (eventResponse) =>
        console.log "ANYONE?", on_finish_event: eventResponse.get('responds_to_event')
        triggerers = @collection.where on_finish_event: eventResponse.get('responds_to_event')
        console.log("Found triggers", triggerers) if triggerers.length
        _(triggerers).each (t) ->
          console.log "t", t
          if t? and t.get('id')?
            console.log('Edging values', t.get('on_finish_event'), eventResponse.get('responds_to_event'))
            graph.addEdge(null, t.get('id'), eventResponse.get('id'))
      renderer = new dagreD3.Renderer()
      # debugger
      renderer.run(graph, d3.select "svg g")
      this

    # TODO: this could be refactored to be more efficient, to be sure
    render1: ->
      console.log("Coll size on render", @collection.size(), @collection)
      chain = $('<div class="chain-container"></div>')
      @collection.each (eventResponse) =>
        element = new EventResponseView(model: eventResponse).render().el
        chain.append element
        chain.append dividerTemplate(eventForNewResponse: eventResponse.eventForNewResponse())
      this.$el.html(chain)
      this.linkNodes()
      this

    render2: ->
      @collection.each (eventResponse) =>
        console.log "Gitting #{eventResponse.get("id")}"
        container = $('<div class="er-container"></div>')
        element = new EventResponseView(model: eventResponse).render().$el

        inResponseTo = this.$el.find("[data-on-finish='#{eventResponse.get('in_response_to_event_name')}']")
        triggers = this.$el.find("[data-in-response='#{eventResponse.get('on_finish_event_name')}']")

        if inResponseTo.length
          # Find other elements that respond to the same event name
          siblings = this.$el.find("[data-in-response='#{eventResponse.get('in_response_to_event_name')}']")
          if siblings.length
            console.log "inserting 0", siblings.closest('.er-container')
            siblings.closest('.er-container').append(element)
          else
            console.log "inserting 1", container
            $(inResponseTo.parent()).after(container.html(element))
        else if triggers.length
          console.log "inserting 2", container
          $(triggers.parent()).before(container.html(element))
        else
          console.log "inserting into 3", container
          this.$el.append(container.html(element))

        for previousElement in inResponseTo
          @linkTwoNodes(previousElement, element[0])
        for nextElement in triggers
          @linkTwoNodes(element[0], nextElement)
      jsPlumb.repaintEverything()
      this

    linkTwoNodes: (source, target) ->
      connectionColor = if target.classList.contains("disabled") then '#ddd' else 'white'
      jsPlumb.connect
        source: source
        target: target
        hoverPaintStyle:
          strokeStyle: 'lightgray'
        paintStyle:
          strokeStyle: connectionColor
          lineWidth: 5
        connector: "Straight"
        endpointStyle:
          fillStyle: connectionColor
          radius: 8
        anchors: ["Bottom", "Top"]

    linkNodes: ->
      @collection.each (eventResponse) ->
        eventName = eventResponse.get('EventName')
        # The target is the element belonging to this eventResponse
        target = $("#event-response-#{eventResponse.get("id")}")[0]
        # The sources are any eventResponses that finish by triggering the event name we listen to
        sources = $("[data-on-finish='#{eventName}']")
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
