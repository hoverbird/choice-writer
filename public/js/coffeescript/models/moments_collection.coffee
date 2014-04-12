define ["jquery", "underscore", "backbone", "models/moment"], ($, _, Backbone, Moment) ->
  MomentsCollection = Backbone.Collection.extend(
    model: Moment

    initialize: (opts = {}) ->
      @url = '/event_responses'
      if constraints = opts.constraints
        if tag = constraints.tag
          @url += "/by_tag/#{tag}"
        else if folder_id = constraints.folder_id
          @url += "/by_folder/#{folder_id}"
        else
          @url += "?#{$.param(opts.constraints)}"
  )
  MomentsCollection
