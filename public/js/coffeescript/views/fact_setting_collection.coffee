define [
  "backbone"
  'hbs!/templates/fact_settings'
], (Backbone, factSettingsTemplate) ->
  FactView = Backbone.View.extend(
    className: 'fact-setting'
    events:
      'click li': 'setFact'

    initialize: (factPairs) ->
      @collection = factPairs

    setFact: (event) ->
      console.log "Setting meh"

    render: ->
      this.$el.html(factSettingsTemplate(@collection))
      this

  )

  FactView
