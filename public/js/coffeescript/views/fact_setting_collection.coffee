define [
  "backbone"
  'hbs!/templates/fact_settings'
  'bootstrap-affix'
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
      # $('.fact-settings-container').affix(
      #   offset:
      #     top: 100
      #     bottom: ->
      #       this.bottom = $('.footer').outerHeight(true)
      # )
      this

  )

  FactView
