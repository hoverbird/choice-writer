define ["backbone", "underscore", "views/moment_view", "models/moment"], (Backbone, _, MomentView, Moment) ->
  MomentsCollectionView = Backbone.View.extend(
    tagName: 'div'

    className: 'moments-collection'

    render: ->
      moments = [
        new Moment(name: "A day in the life")
        new Moment(name: "His last breath")
        new Moment(name: "Their first kiss")
      ]

      _.each moments, (moment) =>
        momentView = new MomentView(model: moment)
        this.$el.append(momentView.render().el)
      this
  )
  MomentsCollectionView
