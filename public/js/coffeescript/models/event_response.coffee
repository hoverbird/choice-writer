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
      @requirementsHash = {}
      _(this.get('Requirements')).each (req) =>
        @requirementsHash[req.Name] = Util.toStrictBoolean(req.FactTestValue)

      this.on "eventResponseUpdated", ->
      this.url = ->
        "/event_responses/#{@id or ''}"

    eventForNewResponse: ->
      # Speech and Triggers both have an on_finish_event_name we can base the new response off of
      this.get('Responses').pluck('on_finish_event_name')[0]

    isDisabled: ->
      this.get('Requirements') and this.get('Requirements').length > 0

    requirementsAreMet: ->
      _(@requirementsHash).every (value, key, obj) ->
        result = window.globalFacts[key] == value
        console.log("NOT MET", value, key, obj) unless result
        result
  )

  EventResponse
