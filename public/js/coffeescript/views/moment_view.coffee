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

    edit: (event) ->
      editableSet = $(event.currentTarget.parentElement)
      editableSet.addClass('editable')
      editableSet.find('input').focus()

    unedit: (event) ->
      editableSet = $(event.currentTarget.parentElement)
      attrs = editableSet.find("input").serializeObject()
      editableSet.removeClass('editable')
      @model.set(attrs).save()

    newMoment: (event) ->
      moment = new Moment(
        previous_moment_id: @model.get('id')
        text: "Who even knowwwwws?"
      )
      console.log "Shubba whut", moment
      newNode = new MomentView(model: moment).render().el
      console.log "Shubba who", newNode
      this.$el.after(newNode)

    render: ->
      this.$el.html(momentTemplate(@model.toJSON()))
      this
  )
  MomentView
