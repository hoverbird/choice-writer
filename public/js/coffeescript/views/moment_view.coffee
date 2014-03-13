define ["backbone", "underscore", 'hbs!/templates/moment'], (Backbone, _, momentTemplate) ->
  MomentView = Backbone.View.extend(
    tagName: 'span'

    # NOTE: className etc. can be functions
    className: 'moment' # card span6 (formerly dialog-line)

    events:
      'dblclick label': 'edit'
      'click h3': 'unedit'

    edit: ->
      console.log "Supness", this

    unedit: ->
      console.log "Nosup", this

    render: ->
      this.$el.html(momentTemplate(@model.toJSON()))
      this
  )
  MomentView
