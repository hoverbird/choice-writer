define ["underscore", "backbone", "backbone-relational"], (_, Backbone) ->
  Response = Backbone.RelationalModel.extend(
    url: '/responses/:id'

    initialize: ->

    gugaw: ->
      console.log "GGGG! G!"
  )
  Response
