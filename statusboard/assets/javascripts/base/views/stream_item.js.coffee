Zepto ($) ->
	class Statusboard.Views.StreamItem extends Backbone.UnbindingView
		tagName: "a"
		className: "item"

		initialize: ->
			_.bindAll @, "render"

			@bindings = []

		render: ->
			template = Handlebars.templates["base/item"]
			@$el.html template @model.toJSON()

			@$el.addClass @model.get "service"

			@$el.prop "href", @model.get("permalink")

			@
