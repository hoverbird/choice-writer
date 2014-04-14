define [
  "underscore"
  "backbone"
  "models/response_collection"
  "models/response"
], (_, Backbone, ResponseCollection, Response) ->
  Moment = Backbone.RelationalModel.extend(
    url: '/moment/:id'

    relations: [{
      key: 'Responses'
      type: Backbone.HasMany
      collectionType: ResponseCollection
      relatedModel: Response
    }]

    initialize: ->
      this.url = ->
        "/event_responses/#{@id or ''}"

    defaults:
      text: "..."

    markdown_text: ->
      this.get('text')

    validate: (attributes) ->
      # return "I'll need a name, bud" unless attributes.name?

  )

  Moment
