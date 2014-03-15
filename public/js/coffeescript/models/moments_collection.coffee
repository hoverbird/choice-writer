define ["jquery", "underscore", "backbone", "models/moment"], ($, _, Backbone, Moment) ->
  MomentsCollection = Backbone.Collection.extend(
    model: Moment

    initialize: (opts) ->
      @url = '/moments'
      if constraints = opts.constraints
        @url += "?#{$.param(opts.constraints)}"
  )
  MomentsCollection
