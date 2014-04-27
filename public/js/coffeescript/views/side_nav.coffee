define ['backbone'], (Backbone, template) ->
  SideNav = Backbone.View.extend(
    el: $('#sidebar')

    events:
      "click .nav a": "navClick"

    navClick: (evt) ->
      this.$el.find(".selected").removeClass("selected")
      $(evt.target).addClass("selected")

  )
  SideNav
