define [
  "backbone"
  "underscore"
  "models/response"
  'hbs!/templates/response'
], (Backbone, _, Response, responseTemplate) ->
  ResponseView = Backbone.View.extend(
    tagName: 'span'

    className: 'response'

    render: ->
      console.log "ResponseView#render", @model.toJSON()
      this.$el.html(responseTemplate @model.toJSON())
      this
  )
