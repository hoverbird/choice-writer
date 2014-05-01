define ["underscore", "backbone", "models/response", "backbone-relational"], (_, Backbone, Response) ->
  ResponseCollection = Backbone.Collection.extend(
    model: Response

    initialize: (responses) ->
      return unless responses?

  )
  ResponseCollection
