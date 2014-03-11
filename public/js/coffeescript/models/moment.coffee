define ["underscore", "backbone"], (_, Backbone) ->
  Moment = Backbone.Model.extend(
    initialize: ->
      this.on 'change', ->
        console.log "I really ought to redraw meself..."

      this.on 'invalid', ->
        console.log "Whoops, I'm no longer valid", this

    defaults:
      name: "A moment in time..."

    markdown_text: ->
      my_text = this.get('text')
      console.log "Textually", my_text
      my_text

    validate: (attributes) ->
      return "I'll need a name, bud" unless attributes.name?
  )

  Moment