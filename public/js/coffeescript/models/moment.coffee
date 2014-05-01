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
      reverseRelation:
        key: 'event_response'
        includeInJSON: 'id'
    }]

    initialize: ->
      this.id = this.get("id") if this.get("id")
      this.on "eventResponseUpdated", ->
        console.log( "YA DURN FUGIN")
      this.url = ->
        "/event_responses/#{@id or ''}"

  )

  Moment
