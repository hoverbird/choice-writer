define ["backbone", "underscore", 'hbs!/templates/moment'], (Backbone, _, momentTemplate) ->
  MomentView = Backbone.View.extend(
    tagName: 'span'

    className: 'moment'

    events:
      'click .replace-text .display': 'edit'
      'blur .replace-text input': 'unedit'

    edit: (event) ->
      editableSet = $(event.currentTarget.parentElement)
      editableSet.addClass('editable')
      editableSet.find('input').focus()

    unedit: (event) ->
      editableSet = $(event.currentTarget.parentElement)
      attrs = editableSet.find("input").serializeObject()
      editableSet.removeClass('editable')
      @model.set(attrs).save()

    render: ->
      this.$el.html(momentTemplate(@model.toJSON()))
      this
  )
  MomentView
