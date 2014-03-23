define [
  "backbone"
  "underscore"
  "models/moment"
  'hbs!/templates/moment'
], (Backbone, _, Moment, momentTemplate) ->
  MomentView = Backbone.View.extend(
    tagName: 'span'

    className: 'moment'

    events:
      'click .replace-text .display': 'edit'
      'blur .replace-text input': 'unedit'
      'click .section-divider': 'newMoment'
      'keyup': 'onKeyUp'

    initialize: ->
      @model.on 'select', this.select.bind(this)

    edit: (event) ->
      @editableSet ||= this.$el.find('.replace-text')
      @editableSet.addClass('editable')
      @editableSet.find('input').focus()

    unedit: (event) ->
      @editableSet ||= this.$el.find('.replace-text')
      attrs = @editableSet.find("input").serializeObject()
      @editableSet.removeClass('editable')
      @model.set(attrs)
      @model.save()
      @changeSelection()

    changeSelection: ->
      Backbone.pubSub.trigger 'selectNextMoment', id: @model.get('id')

    select: ->
      console.log "I'm a VIEW and I've changed selection", this
      this.edit()

    onKeyUp: (event) ->
      if event.keyCode is 13 and event.shiftKey
        @unedit(event)

    newMoment: (event) ->
      moment = new Moment(
        previous_moment_id: @model.get('id')
        text: "..."
      )
      moment.save()
      newNode = new MomentView(model: moment).render().el
      this.$el.after(newNode)

    textColor: ->
      colorMap =
        "henry": "red"
        "delilah": "blue"
      charName = @model.get('character')
      if charName and characterColor = colorMap[charName.toLowerCase()]
        characterColor
      else
        "black"

    render: ->
      viewData = _.extend(@model.toJSON(), textColor: @textColor())
      this.$el.html(momentTemplate(viewData))
      this
  )
  MomentView
