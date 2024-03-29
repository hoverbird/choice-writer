define ["backbone", "jquery"], (Backbone, $) ->
  appRoot = "#{location.protocol}//#{location.host}/"
  Backbone.pubSub = _.extend({}, Backbone.Events)

  $.fn.serializeObject = ->

    json = {}
    push_counters = {}
    patterns =
      validate  : /^[a-zA-Z][a-zA-Z0-9_]*(?:\[(?:\d*|[a-zA-Z0-9_]+)\])*$/
      key       : /[a-zA-Z0-9_]+|(?=\[\])/g
      push      : /^$/
      fixed     : /^\d+$/
      named     : /^[a-zA-Z0-9_]+$/

    @build = (base, key, value) ->
      base[key] = value
      base

    @push_counter = (key) ->
      push_counters[key] = 0 if push_counters[key] is undefined
      push_counters[key]++

    $.each $(@).serializeArray(), (i, elem) =>
      return unless patterns.validate.test(elem.name)

      keys = elem.name.match patterns.key
      merge = elem.value
      reverse_key = elem.name

      while (k = keys.pop()) isnt undefined

        if patterns.push.test k
          re = new RegExp("\\[#{k}\\]$")
          reverse_key = reverse_key.replace re, ''
          merge = @build [], @push_counter(reverse_key), merge

        else if patterns.fixed.test k
          merge = @build [], k, merge

        else if patterns.named.test k
          merge = @build {}, k, merge
      json = $.extend true, json, merge
    return json

  Util = {
    toStrictBoolean: (value) ->
      throw "Can't toStrictBoolean #{value}" unless value?
      return value if typeof value is "boolean"
      switch value.toLowerCase()
        when 't' then true
        when 'f' then false
        else null

    railsifyBackbone: ->
      # alias away the sync method
      Backbone._sync = Backbone.sync

      # define a new sync method
      Backbone.sync = (method, model, success, error) ->

        # only need a token for non-get requests
        if method is "create" or method is "update" or method is "delete"

          # grab the token from the meta tag rails embeds
          auth_options = {}
          auth_options[$("meta[name='csrf-param']").attr("content")] = $("meta[name='csrf-token']").attr("content")

          # set it as a model attribute without triggering events
          model.set auth_options,
            silent: true
        # proxy the call to the old sync method
        Backbone._sync method, model, success, error

    setupNav: ->
      $('.nav-search').on "submit", (event) ->
        event.preventDefault()
        queryString = $(event.target).find("#search-query").val()
        Backbone.history.navigate("search?q=#{encodeURIComponent(queryString)}", true)

      $('.nav').on "click", "a:not([data-bypass])", (event) ->
        href =
          prop: $(this).prop("href")
          attr: $(this).attr("href")

        if href.prop and href.prop.slice(0, appRoot.length) == appRoot
          event.preventDefault()
          Backbone.history.navigate(href.attr, true)

  }
  Util
