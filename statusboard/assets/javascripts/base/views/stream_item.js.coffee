Zepto ($) ->
	class Statusboard.Views.StreamItem extends Backbone.UnbindingView
		className: "item"

		initialize: ->
			_.bindAll @, "render"

			@bindings = []
			@bindTo @model, "change:photo_url", @render

		render: ->
			item_type = @model.get "statusboard_type"
			template = Handlebars.templates["apps/#{item_type}/item"]

			@$el.html template @model.toJSON()

			@
