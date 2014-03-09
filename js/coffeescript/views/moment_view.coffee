define ["backbone", "underscore", 'hbs!/templates/moment'], (Backbone, _, momentTemplate) ->
  MomentView = Backbone.View.extend(
    tagName: 'div'

    # NOTE: className etc. can be functions
    className: 'dialog-line card span6'

    # momentTemplate: _.template "<h3><%= name %></h3>: <label>Click me</label>"

    events:
      'dblclick label': 'edit'
      'click h3': 'unedit'

    edit: ->
      console.log "Supness", this

    unedit: ->
      console.log "Nosup", this

    render: ->
      console.log "Rendering a moment view", @model
      this.$el.html(momentTemplate(@model.toJSON()))
      this
  )
  MomentView
