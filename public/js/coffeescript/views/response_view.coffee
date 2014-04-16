define [
  "backbone"
  "underscore"
  'hbs!/templates/speech_response'
  'hbs!/templates/fact_response'
  'hbs!/templates/dialog_tree_response'
], (Backbone, _, SpeechResponseTmpl, FactResponseTmpl, DialogTreeResponseTmpl) ->

  ResponseView = Backbone.View.extend(

    initialize: ->
      @responseTemplate = switch @model.get("Type")
        when "SpeechResponse" then SpeechResponseTmpl
        when "FactResponse" then FactResponseTmpl
        when "DialogTreeResponse" then DialogTreeResponseTmpl
        else throw "Can't render; unknown Response Type"

    className: ->
      "response #{@model.cleanType()}-response"

    render: ->
      this.$el.html @responseTemplate(@model.toJSON())
      this
  )
