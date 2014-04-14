define ["underscore", "backbone", "models/response", "backbone-relational"], (_, Backbone, Response) ->
  ResponseCollection = Backbone.Collection.extend(
    model: Response

    url: "event_response/responses/:id"

    initialize: (responses) ->
      return unless responses?

  )
  ResponseCollection
