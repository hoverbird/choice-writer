define ["underscore", "backbone", "backbone-relational"], (_, Backbone) ->
  Response = Backbone.RelationalModel.extend(
    url: ->
      "/responses/#{this.get('id')}"

    initialize: ->
      # this.on 'fetch', ->
      #   console.log "Response", this.toJSON()

      this.on 'change:text', ->
        @parseText() if @get("Type") is "SpeechResponse"

      # this.on 'change:tags', ->
      #   console.log "change:tags", @get('id')
      #
      # this.on 'change:character', ->
      #   console.log "change:character", @get('character')

      this.on 'invalid', ->
        console.log "Whoops, I'm no longer valid", this

    regexen:
      characterName: /^[a-zA-z0-9]*:/
      hashTags: /#[a-zA-z0-9]*\b/g
      requirements: /{()}/g

    cleanType: ->
      @get("Type").slice(0, -8).toLowerCase()

    parseText: ->
      text = this.get('text')
      if text
        characterName = text.match(@regexen.characterName)
        # hashTags = text.match(@regexen.hashTags)
        this.set(character: characterName[0]) if characterName?
        # this.set(Tags: hashTags) if hashTags?

    validate: (attributes) ->
      # return "I'll need a name, bud" unless attributes.name?

  )
  Response
