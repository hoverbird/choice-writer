define [
  "underscore"
  "backbone"
  "util"
  "models/response_collection"
  "models/response"
], (_, Backbone, Util, ResponseCollection, Response) ->

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
      this.get('Responses').pluck('on_finish_event_name')[0]

    isDisabled: ->
      this.get('Requirements') and this.get('Requirements').length > 0

    requirementsHash: ->
      hash = {}
      _(this.get('Requirements')).each (req) ->
        hash[req.Name] = Util.toStrictBoolean(req.FactTestValue)
      hash
  )

  EventResponse
