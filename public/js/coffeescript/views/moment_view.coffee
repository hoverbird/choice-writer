define ["backbone", "underscore", 'hbs!/templates/moment'], (Backbone, _, momentTemplate) ->
  MomentView = Backbone.View.extend(
    tagName: 'span'

    # NOTE: className etc. can be functions
    className: 'moment'

    events:
      'click .display': 'edit'
      'blur input': 'unedit'

    edit: ->
      this.$el.addClass('editable')
      this.$el.find('input').focus()

    unedit: ->
      attrs = this.$el.find("input").serializeObject()
      @model.set(attrs)
      @model.save()
      this.$el.removeClass('editable')

    render: ->
      this.$el.html(momentTemplate(@model.toJSON()))
      this
  )
  MomentView
