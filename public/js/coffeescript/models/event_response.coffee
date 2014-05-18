define [
  "underscore"
  "backbone"
  "models/response_collection"
  "models/response"
], (_, Backbone, ResponseCollection, Response) ->
  EventResponse = Backbone.RelationalModel.extend(
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
      this.url = ->
        "/event_responses/#{@id or ''}"

    eventForNewResponse: ->
      # Speech and Triggers both have an on_finish_event_name we can base the new response off of
      # eventToTrigger = _(this.get('Responses').models).find (response) ->
      #   response.get('Type') is "SpeechResponse" or response.get('Type') is "TriggerEventResponse"
      # eventToTrigger.get("on_finish_event_name") if eventToTrigger

      this.get('Responses').pluck('on_finish_event_name')[0]

  )

  EventResponse
