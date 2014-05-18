define [
  "jquery"
  "underscore"
  "backbone"
  "models/event_response"
], ($, _, Backbone, EventResponse) ->
  EventResponseCollection = Backbone.Collection.extend(
    model: EventResponse

    initialize: (opts = {}) ->
      # this.on "add", (er) ->

      @url = '/event_responses/v0/web'
      if constraints = opts.constraints
        if query = constraints.searchQuery
          @url += "/search?#{query}"
        else if permalinkId = constraints.permalinkId
          console.log "permalinkId", permalinkId
          @url += "/#{permalinkId}"
        else if tag = constraints.tag
          @url += "/by_tag/#{tag}"
        else if folder_id = constraints.folder_id
          @url += "/by_folder/#{folder_id}"
        else
          @url += "?#{$.param(opts.constraints)}"
      @url
  )
  EventResponseCollection
