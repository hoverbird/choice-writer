define ['backbone', 'hbs!/templates/locations'], (Backbone, template) ->
  MomentView = Backbone.View.extend(
    tagName: 'span'

    className: 'locations'

    render: ->
      this.$el.html(momentTemplate(@model.toJSON()))
      this
  )
  MomentView
