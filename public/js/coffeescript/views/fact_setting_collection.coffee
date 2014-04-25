define [
  "backbone"
  'hbs!/templates/fact_settings'
], (Backbone, factSettingsTemplate) ->
  FactView = Backbone.View.extend(
    className: 'fact-setting'

    initialize: (factPairs) ->
      @collection = factPairs
      console.log "Innitting with", factPairs

    render: ->
      this.$el.html(factSettingsTemplate(@collection))
      this

  )

  FactView
