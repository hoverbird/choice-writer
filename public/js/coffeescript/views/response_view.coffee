define [
  "backbone"
  "underscore"
  'hbs!/templates/speech_response'
  'hbs!/templates/fact_response'
  'hbs!/templates/dialog_tree_response'
], (Backbone, _, SpeechResponseTmpl, FactResponseTmpl, DialogTreeResponseTmpl) ->

  ResponseView = Backbone.View.extend(
    events:
      'click .replace-text .display': 'edit'
      'blur  .replace-text .input': 'unedit'

    initialize: ->
      @responseTemplate = switch @model.get("Type")
        when "SpeechResponse" then SpeechResponseTmpl
        when "FactResponse" then FactResponseTmpl
        when "DialogTreeResponse" then DialogTreeResponseTmpl
        when "TriggerEventResponse" then SpeechResponseTmpl
        else
          throw "Unknown Response Type: #{@model.get("Type")}"

    className: ->
      "response #{@model.cleanType()}-response"

    edit: (event) ->
      @editableSet ||= $(event.target.parentElement)
      @editableSet.addClass('editable')
      @editableSet.find('.input').focus()

    unedit: (event) ->
      @editableSet ||= $(event.target.parentElement)
      input = @editableSet.find(".input")
      attrs = input.serializeObject()

      # Replace the html of the display element with the value of the input
      @editableSet.find(".#{input[0].name}").html(input[0].value)

      @editableSet.removeClass('editable')
      @model.set(attrs)

      @model.save()
      @model.get("event_response").trigger("responseUpdated")
      # select the next moment (i.e. the moment AFTER this one)
      # @changeSelection afterId: @model.get('id')

    render: ->
      this.$el.html @responseTemplate(@model.toJSON())
      this
  )
