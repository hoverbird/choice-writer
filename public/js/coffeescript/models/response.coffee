define ["underscore", "backbone", "backbone-relational"], (_, Backbone) ->
  Response = Backbone.RelationalModel.extend(
    url: '/responses/:id'

    initialize: ->
      this.on 'fetch', -> console.log "Response", this.toJSON()

      this.on 'change:Caption', ->
        console.log "Response change:Caption", this.toJSON() # @get('id'), @get('Caption')
        @parseText() if @get("Type") is "SpeechResponse"

      this.on 'change:tags', ->
        console.log "change:tags", @get('id')

      this.on 'change:character', ->
        console.log "change:character", @get('id')

      this.on 'invalid', ->
        console.log "Whoops, I'm no longer valid", this


    regexen:
      characterName: /^[a-zA-z0-9]*(?=:)/
      hashTags: /#[a-zA-z0-9]*\b/g
      requirements: /{()}/g

    parseText: ->
      text = this.get('Caption')
      characterName = text.match(@regexen.characterName)
      hashTags = text.match(@regexen.hashTags)
      this.set(character: characterName[0]) if characterName?
      this.set(tags: hashTags) if hashTags?

  )
  Response
