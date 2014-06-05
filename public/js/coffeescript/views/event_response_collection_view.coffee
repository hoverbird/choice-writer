define [
  "backbone"
  "jquery"
  "underscore"
  "models/event_response_collection"
  "models/event_response"
  "models/response"
  "views/event_response_view"
  "views/fact_setting_collection"
  "hbs!/templates/event_response_divider"
  'bootstrap-dropdown'
  'dagreD3'
], (Backbone, $, _, EventResponseCollection, EventResponse, Response,
    EventResponseView, FactSettingsView, dividerTemplate) ->
  EventResponseCollectionView = Backbone.View.extend(
    tagName: 'div'

    events:
      'click .event-response-divider': 'newEventResponse'

    className: 'event-response-collection'

    initialize: (viewOptions) ->
      Backbone.pubSub.on('selectMoment', this.selectMoment, this)
      @renderer = new dagreD3.Renderer().drawEdgePaths(@customDrawEdgePaths)

      @collection = new EventResponseCollection(viewOptions)
      @collection.bind "change", _.bind(this.render, this)
      @collection.fetch success: (data) =>
        @renderFacts.call(this, data)
        @render.call(this, data)

    customDrawEdgePaths: (g, root) ->
      svgEdgePaths = root.selectAll("g.edgePath").classed("enter", false).data(g.edges(), (e) -> e)
      svgEdgePaths.enter().append("g").attr("class", "edgePath enter").append("path").style("opacity", 0)#.attr "marker-end", "url(#arrowhead)"
      @_transition(svgEdgePaths.exit()).style("opacity", 0).remove()
      svgEdgePaths

    customTransition: (selection) -> selection.transition().duration(500)

    # Selects another moment in the collection. Options should contain either an
    # id OR an afterId key, depending on whether we know the moment to select or
    # whether it is relative selection (e.g. you want the moment AFTER another)

    # selectMoment: (options) ->
    #   console.log("selectMoment", options)
    #   momentToSelect = if options.afterId
    #     @findEventResponseAfter options.afterId
    #   else if options.id
    #     @findEventResponse options.id
    #   else
    #     throw "You can't select a moment without its ID!"
    #   console.log("gonna trigger select", momentToSelect[0])
    #   if momentToSelect.length
    #     momentToSelect[0].trigger('select')
    #   else
    #     # If no moment was found, we create a new one.
    #     this.newEventResponse previousMomentId: momentToSelect.id

    # findEventResponseAfter: (id) ->
    #   @collection.select (eventResponse) -> eventResponse.get('previous_moment_id') is id

    # newEventResponse: (event) ->
    #   eventName = $(event.target).data("event-for-new-response")
    #   er = new EventResponse(EventName: eventName, folder_id: 3) # TODO: MAKE THIS NOT FAKE
    #   resp = new Response(Type: "SpeechResponse", event_response: er, text: "Just checked in to see what condition my condition was in")
    #   console.log("Coll size before add", @collection.size())
    #   @collection.add er
    #   @render()
    #   # er.trigger 'select'

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

    drawLayout: (graph) ->
      svg = $("<svg width='100%' height='100%'>
          <g transform='translate(20,20)'/>
      </svg>
      ")
      this.$el.append svg
      layout = dagreD3.layout().nodeSep(60).rankDir("LR")

      drawnLayout = @renderer.layout(layout).run(graph, d3.select "svg g")

      @renderer.transition(@customTransition);

      d3svg = d3.select("svg")
      @customTransition(d3svg)
        .attr("width", $(window).width())#drawnLayout.graph().width + 40)
        .attr("height", $(window).height())

      d3svg.call(d3.behavior.zoom().on "zoom", ->
        ev = d3.event
        d3svg.select("g").attr "transform", "translate(#{ev.translate}) scale(#{ev.scale})"
      )
      this

    buildGraph: ->
      graph = new dagreD3.Digraph()
      console.log(@collection)
      @collection.each (eventResponse) =>
        console.log(eventResponse.get("Responses").pluck("text"))
        view = new EventResponseView(model: eventResponse).render()
        graph.addNode(eventResponse.get('id'), label: view.htmlString)
      @collection.each (eventResponse) =>
        triggerers = @collection.where on_finish_event: eventResponse.get('responds_to_event')
        _(triggerers).each (t) ->
          if t? and t.get('id')?
            graph.addEdge(null, t.get('id'), eventResponse.get('id'))
      graph

    render: -> @drawLayout(@buildGraph())

  )
  EventResponseCollectionView
