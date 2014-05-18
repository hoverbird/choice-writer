define ['backbone'], (Backbone) ->
  SideNav = Backbone.View.extend(

    initialize: ->
      folderId = Backbone.history.fragment.match(/by_folder\/([0-9]*)/)
      $("#folder-#{folderId[1]}").addClass("selected") if folderId.length

    el: $('#sidebar')

    events:
      "click .nav a": "navClick"

    navClick: (evt) ->
      this.$el.find(".selected").removeClass("selected")
      $(evt.target).addClass("selected")

  )
  SideNav
