define ['backbone'], (Backbone, template) ->
  SideNav = Backbone.View.extend(
    el: $('#sidebar')

    # events:
    #   "click .nav a": "navClick"
    #
    # navClick: ->
    #   console.log "clicked", this
  )
  SideNav
