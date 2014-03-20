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
      @model.on('select', this.select.bind(this))

    edit: (event) ->
      editableSet = this.$el.find('.replace-text')
      console.log("edit", editableSet[0])
      editableSet.addClass('editable')
      editableSet.find('input').focus()

    unedit: (event) ->
      editableSet = $(event.currentTarget.parentElement)
      attrs = editableSet.find("input").serializeObject()
      editableSet.removeClass('editable')
      @model.set(attrs)
      @model.save()
      @changeSelection()

    changeSelection: ->
      Backbone.pubSub.trigger 'selectNextMoment', id: @model.get('id')

    select: ->
      console.log "I'm a VIEW and I've changed selection", this
      this.edit()

    onKeyUp: (event) ->
      console.log 'onKeyUp', event.target
      if event.keyCode is 13 and event.shiftKey
        console.log 'shiftEnter'
        @unedit(event)

      #   content = @value
      #   caret = getCaret(this)
      #   @value = content.substring(0, caret) + "\n" + content.substring(carent, content.length - 1)
      #   event.stopPropagation()
      # else $("form").submit()  if event.keyCode is 13
      # return

    newMoment: (event) ->
      moment = new Moment(
        previous_moment_id: @model.get('id')
        text: "Who even knowwwwws?"
      )
      moment.save()
      newNode = new MomentView(model: moment).render().el
      this.$el.after(newNode)

    render: ->
      this.$el.html(momentTemplate(@model.toJSON()))
      this
  )
  MomentView
