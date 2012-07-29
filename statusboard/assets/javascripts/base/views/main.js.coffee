Zepto ($) ->
	class Statusboard.Views.Main extends Backbone.UnbindingView
		tagName: "section"
		id: "wrapper"
		template: Handlebars.templates["base/layout"]

		initialize: ->
			_.bindAll @, "render"

			@bindings = Statusboard.State.bindings
			@bindTo @collection, "reset", @render
			@child_views = []

			_fetch = (collection) ->
				collection.fetch
					add: true

			Statusboard.State.autorefresh = setInterval ->
				_fetch Statusboard.Collections.items
			, Statusboard.State.autorefresh_delay

		render: ->
			@$el.html @template
				hashtag: Statusboard.State.hashtag
				headline: Statusboard.State.headline

			stream = new Statusboard.Views.Stream
				collection: @collection
			@$el.find("#pageBody").append stream.render().el
			@child_views.push stream

			@
