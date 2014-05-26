define [
  "backbone"
  "underscore"
  "models/event_response"
  "views/response_collection_view"
  'hbs!/templates/event_response'
], (Backbone, _, EventResponse, ResponseCollectionView, eventResponseTemplate) ->
  EventResponseView = Backbone.View.extend(
    className: "event-response"

    id: -> "event-response-#{@model.get('id')}"

    attributes: ->
      'data-in-response': @model.get("in_response_to_event_name")
      'data-on-finish': @model.get("on_finish_event_name")

    events:
      'click .section-divider': 'newEventResponse'
      # 'click .replace-text .display': 'edit'
      # 'blur .replace-text input': 'unedit'
      # 'keyup': 'onKeyUp'

    initialize: ->
      @model.on 'select', this.select.bind(this)

    edit: (event) ->
      @editableSet ||= $(event.target.parentElement)
      @editableSet.addClass('editable')
      @editableSet.find('input').focus()

    unedit: (event) ->
      @editableSet ||= $(event.target.parentElement)
      attrs = @editableSet.find("input").serializeObject()
      @editableSet.removeClass('editable')
      @model.set(attrs)
      @model.save()
      # select the next event response (i.e. the one AFTER this one)
      @changeSelection afterId: @model.get('id')

    # options: hash of either a momentId or an afterId
    changeSelection: (options) ->
      Backbone.pubSub.trigger('selectMoment', options)

    select: -> this.edit()

    destroy: ->
      @model.destroy success: (model, response) => this.$el.remove()

    onKeyUp: (event) ->
      @unedit(event) if event.keyCode is 13 and event.shiftKey

    # TODO: unify this with collection view creation
    newEventResponse: (event) ->
      er = new EventResponse(previous_moment_id: @model.get('id'))
      er.save()
      newNode = new EventResponseView(model: er).render().el
      this.$el.after(newNode)
      # select the newly created event response
      er.trigger('select')

    textColor: ->
      charName = @model.get('character')
      colorMap =
        "henry": "#EB5C47"
        "delilah": "#EE7F50"
        "dir": "blue"
      if charName and characterColor = colorMap[charName.toLowerCase()]
        characterColor
      else
        "black"

    render: ->
      viewData = _.extend(@model.toJSON(), textColor: @textColor())
      this.$el.html(eventResponseTemplate(viewData))
      if (response_collection = @model.get("Responses")) and response_collection.length
        responseViews = new ResponseCollectionView(responses: response_collection.models)
        responseViews.$el.insertAfter(this.$el.find(".pre-response"))
      this
  )
  EventResponseView
