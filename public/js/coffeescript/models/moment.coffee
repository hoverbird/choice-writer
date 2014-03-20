define ["underscore", "backbone"], (_, Backbone) ->
  Moment = Backbone.Model.extend(
    url: '/moment/:id'

    initialize: ->
      this.setTextColor()

      this.url = ->
        "/moments/#{@id or ''}"

      this.on 'fetch', ->
        console.log "YAYson", this.toJSON()

      this.on 'change:text', ->
        console.log "change:text"
        @parseText()

      this.on 'change:tags', ->
        console.log "change:tags"

      this.on 'invalid', ->
        console.log "Whoops, I'm no longer valid", this

      # this.on "select", ->
      #   console.log "I'm a Selected MODEL", this

    defaults:
      name: "A moment in time..."

    markdown_text: ->
      this.get('text')

    setTextColor: ->
      colorMap =
        "henry": "red"
        "delilah": "blue"
      charName = this.get('character')
      if charName and characterColor = colorMap[charName.toLowerCase()]
        color = characterColor
      else
        color = "black"
      this.set(textColor: color)

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
      this.set(character: characterName)
      this.set(tags: hashTags)
  )

  Moment
