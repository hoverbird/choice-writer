define ["backbone", "underscore"], (Backbone, _) ->
  MomentView = Backbone.View.extend(
    tagName: 'div'

    # NOTE: className etc. can be set to functions
    className: 'dialog-line card span6'

    momentTemplate: _.template "just testing <%= name %>"

    events:
      'dblclick label': 'edit'
      'blur .edit': 'unedit'

    render: ->
      this.$el.html(@momentTemplate( @model.toJSON()))
      this
  )
  MomentView
