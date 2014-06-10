define [
  "backbone"
  "util"
  'hbs!/templates/fact_settings'
  'bootstrap-affix'
], (Backbone, Util, factSettingsTemplate) ->
  FactView = Backbone.View.extend(
    className: 'fact-setting'
    events:
      'click input': 'setFact'

    initialize: (factPairs) ->
      @collection = factPairs

    setFact: (event) ->
      fact = event.target.value
      value = event.target.checked
      window.globalFacts[fact] = value
      Backbone.pubSub.trigger('factIsSet', fact: value)

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
