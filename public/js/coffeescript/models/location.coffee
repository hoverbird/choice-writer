define ["underscore", "backbone"], (_, Backbone) ->
  Location = Backbone.Model.extend(
    validate: (attributes) -> "Every location needs a name, bud" unless attributes.name?
  )

  Moment
