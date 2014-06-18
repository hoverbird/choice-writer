define [
  "backbone"
  "jquery"
  "underscore"
  "util"
  "models/event_response_collection"
  "models/event_response"
  "models/response"
  "views/event_response_view"
  "views/fact_setting_collection"
  "hbs!/templates/event_response_divider"
  'bootstrap-dropdown'
  'dagreD3'
], (Backbone, $, _, Util, EventResponseCollection, EventResponse, Response,
    EventResponseView, FactSettingsView, dividerTemplate) ->

  EventResponseCollectionView = Backbone.View.extend(
    tagName: 'div'

    events:
      'click .event-response-divider': 'newEventResponse'

    className: 'event-response-collection'

    initialize: (viewOptions = {}) ->
      @facts = window.globalFacts = {};

      Backbone.pubSub.on('selectMoment', this.selectMoment, this)
      Backbone.pubSub.on('factIsSet', this.render, this)

      @renderer = new dagreD3.Renderer()
        .drawEdgePaths(@customDrawEdgePaths)
        .postLayout(@postLayout)
        .postRender(@postRender)

      # Monkeypatch the node drawing function
      oldDrawNodes = @renderer.drawNodes()
      @renderer.drawNodes (graph, root) ->
        console.log "DRAWNODES"
        svgNodes = oldDrawNodes(graph, root)
        nodeClassifier = (u) ->
          classes = "node enter node-#{u} "
          node = graph.node(u)

          if reachable = node.requirementsMet
            if priorNodeID = graph.predecessors(u)[0]
              reachable = false if not graph.node(priorNodeID).requirementsMet
              # and priorNode.attr("class").indexOf("unreachable") > 0
              console.log "not reachable because of prior node"

          if reachable
            console.log "removing class", u
            classes.replace "unreachable", ''
          else
            # console.log "adding class", u
            classes += "unreachable"
          classes

        svgNodes.attr "class", nodeClassifier.bind(this)
        svgNodes

      @collection = new EventResponseCollection(viewOptions)
      @collection.bind "change", _.bind(this.render, this)
      @collection.fetch success: (data) =>
        @gatherFacts.call(this)
        @renderFacts.call(this)
        @render.call(this)

    customDrawEdgePaths: (g, root) ->
      svgEdgePaths = root.selectAll("g.edgePath").classed("enter", false).data(g.edges(), (e) -> e)
      svgEdgePaths.enter().append("g").attr("class", "edgePath enter").append("path").style("opacity", 0)#.attr "marker-end", "url(#arrowhead)"
      @_transition(svgEdgePaths.exit()).style("opacity", 0).remove()
      svgEdgePaths

    customTransition: (selection) -> selection.transition().duration(500)

    # Gather a hash of facts and default values as referenced in all reqs and resps
    # in the collection. We should probably do this on the server.
    gatherFacts: ->
      _(@collection.models).each (er) =>
        if responses = er.get("Responses")
          _(responses.models).each (resp) =>
            if resp and resp.get("Type") is "FactResponse"
              window.globalFacts[resp.get("name")] = Util.toStrictBoolean(resp.get("default_status"))
        if requirements = er.get("Requirements")
          _(requirements).each (req) =>
            debugger unless req.default_status
            window.globalFacts[req.name] = Util.toStrictBoolean(req.default_status)

    renderFacts: ->
      $('.fact-settings-container').html(new FactSettingsView(@facts).render().el)

    postRender: (r) ->
      # console.log "postRender", r

    postLayout: (lg) ->
      # console.log "postLayout", lg

      minY = Math.min.apply(null, lg.nodes().map (u) ->
        value = lg.node(u)
        value["ul"] - value.width / 2
      )

      # Update node positions
      lg.eachNode (u, value) ->
        value.y = value["ul"] - minY

      # Update edge positions
      lg.eachEdge (e, u, v, value) ->
        value.points.forEach (p) ->
          p.y = p["ul"] - minY

    applyLogic: (graph) ->
      console.log "after render", graph

    drawLayout: (graph) ->
      svg = $("<svg width='100%' height='100%'><g transform='translate(20,20)'/></svg>")
      this.$el.append(svg)

      nodeSep = Math.min(
        Math.max(@collection.length / 2.5, 60),
      250)
      console.log(nodeSep)
      layout = dagreD3.layout().nodeSep(nodeSep).rankDir("LR").debugLevel(0)

      drawnLayout = @renderer.layout(layout).run(graph, d3.select "svg g")
      @renderer.transition(@customTransition)

      d3svg = d3.select("svg")
      @customTransition(d3svg)
        .attr("width", $(window).width())
        .attr("height", $(window).height())

      d3svg.call(d3.behavior.zoom().on "zoom", ->
        ev = d3.event
        d3svg.select("g").attr "transform", "translate(#{ev.translate}) scale(#{ev.scale})"
      )
      graph

    buildGraph: ->
      @graph = new dagreD3.Digraph()
      @collection.each (eventResponse) =>
        view = new EventResponseView(model: eventResponse).render()
        @graph.addNode(eventResponse.get('id'),
          label: view.htmlString,
          respondsTo: eventResponse.get("responds_to_event")
          facts: eventResponse.requirementsHash
          requirementsMet: eventResponse.requirementsAreMet()
        )
      @collection.each (eventResponse) =>
        triggerers = @collection.where on_finish_event: eventResponse.get('responds_to_event')
        _(triggerers).each (t) =>
          if t? and t.get('id')?
            @graph.addEdge(null, t.get('id'), eventResponse.get('id'), reqCount: t.get("requirements_count"))
      @graph

    render: -> @applyLogic(@drawLayout(@buildGraph()))

  )
  EventResponseCollectionView
