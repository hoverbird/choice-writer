define [
  "jquery"
  "underscore"
  "backbone"
  "models/event_response"
], ($, _, Backbone, EventResponse) ->
  EventResponseCollection = Backbone.Collection.extend(
    model: EventResponse

    initialize: (opts = {}) ->
      @url = '/event_responses/v0/web'
      if constraints = opts.constraints
        if query = constraints.searchQuery
          @url += "/search?#{query}"
        else if respondsToEvent = constraints.respondsToEvent
          @url += "/responds_to_event/#{respondsToEvent}"
        else if permalinkId = constraints.permalinkId
          @url += "/#{permalinkId}"
        else if folder_id = constraints.folder_id
          @url += "/by_folder/#{folder_id}"
        else
          @url += "?#{$.param(opts.constraints)}"
      @url
  )
  EventResponseCollection
