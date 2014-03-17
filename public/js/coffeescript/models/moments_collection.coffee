define ["jquery", "underscore", "backbone", "models/moment"], ($, _, Backbone, Moment) ->
  MomentsCollection = Backbone.Collection.extend(
    model: Moment

    initialize: (opts = {}) ->
      console.log("Moments collection", opts)
      @url = '/moments'
      if constraints = opts.constraints
        if tag = constraints.tag
          @url += "/by_tag/#{tag}"
        else
          @url += "?#{$.param(opts.constraints)}"
  )
  MomentsCollection
