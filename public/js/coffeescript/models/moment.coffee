define ["underscore", "backbone"], (_, Backbone) ->
  Moment = Backbone.Model.extend(
    url: '/moment/:id'

    initialize: ->
      this.url = ->
        "/moments/#{@id or ''}"

      this.on 'fetch', -> console.log "YAYson", this.toJSON()

      this.on 'change:text', ->
        console.log "change:text"
        @parseText()

      this.on 'change:tags', ->
        console.log "change:tags"

      this.on 'change:character', ->
        console.log "change:character"

      this.on 'invalid', ->
        console.log "Whoops, I'm no longer valid", this

    defaults:
      name: ""

    markdown_text: ->
      this.get('text')

    validate: (attributes) ->
      # return "I'll need a name, bud" unless attributes.name?

    regexen:
      characterName: /^[a-zA-z0-9]*(?=:)/
      hashTags: /#[a-zA-z0-9]*\b/g

    parseText: ->
      text = this.get('text')
      characterName = text.match(@regexen.characterName)
      hashTags = text.match(@regexen.hashTags)
      console.log("parsetext!!!", characterName, hashTags)
      this.set(character: characterName[0])
      this.set(tags: hashTags)
  )

  Moment
