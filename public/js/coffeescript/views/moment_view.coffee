define [
  "backbone"
  "underscore"
  "models/moment"
  'hbs!/templates/moment'
], (Backbone, _, Moment, momentTemplate) ->
  MomentView = Backbone.View.extend(
    tagName: 'span'

    className: 'moment'

    events:
      'click .section-divider': 'newMoment'
      'click .delete': 'destroy'
      'click .replace-text .display': 'edit'
      'blur .replace-text input': 'unedit'
      'keyup': 'onKeyUp'

    initialize: ->
      @model.on 'select', this.select.bind(this)
      # this.on 'blur', this.gotMeh.bind(this)

    edit: (event) ->
      @editableSet ||= this.$el.find('.replace-text')
      @editableSet.addClass('editable')
      @editableSet.find('input').focus()

    unedit: (event) ->
      @editableSet ||= this.$el.find('.replace-text')
      attrs = @editableSet.find("input").serializeObject()
      @editableSet.removeClass('editable')
      @model.set(attrs)
      @model.save()
      # select the next moment (i.e. the moment AFTER this one)
      @changeSelection afterId: @model.get('id')

    # options: hash of either a momentId or an afterId
    changeSelection: (options) ->
      Backbone.pubSub.trigger('selectMoment', options)

    select: -> this.edit()

    destroy: ->
      @model.destroy success: (model, response) => this.$el.remove()

    onKeyUp: (event) ->
      if event.keyCode is 13 and event.shiftKey
        @unedit(event)

    # TODO: unify this with collection view creation
    newMoment: (event) ->
      moment = new Moment(previous_moment_id: @model.get('id'))
      moment.save()
      console.log("MomentView#newMoment", moment.get('id'))
      newNode = new MomentView(model: moment).render().el
      this.$el.after(newNode)
      # select the newly created moment
      moment.trigger('select')

    textColor: ->
      colorMap =
        "henry": "#EB5C47"
        "delilah": "#EE7F50"
      charName = @model.get('character')
      if charName and characterColor = colorMap[charName.toLowerCase()]
        characterColor
      else
        "black"

    render: ->
      viewData = _.extend(@model.toJSON(), textColor: @textColor())
      this.$el.html(momentTemplate(viewData))
      this
  )
  MomentView
