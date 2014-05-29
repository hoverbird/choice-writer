define [
  "backbone"
  'hbs!/templates/fact_settings'
  'bootstrap-affix'
], (Backbone, factSettingsTemplate) ->
  FactView = Backbone.View.extend(
    className: 'fact-setting'
    events:
      'click input': 'setFact'

    initialize: (factPairs) ->
      @collection = factPairs

    setFact: (event) ->
      factName = event.target.name
      value = event.target.value
      factDivs = $(".requirement[data-name='#{factName}']")
      factDivs.closest(".event-response").removeClass("disabled")

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
