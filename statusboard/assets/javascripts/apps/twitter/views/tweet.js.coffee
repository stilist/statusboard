jQuery ($) ->
	class Twitter.Views.Tweet extends Backbone.View
		tagName: "section"
		className: "item"
		template: Handlebars.templates["apps/twitter/tweet"]

		initialize: ->
			_.bindAll @, "render"

			@collection.on "reset", @render

		render: ->
			@$el.html @template @model.toJSON()

			@
