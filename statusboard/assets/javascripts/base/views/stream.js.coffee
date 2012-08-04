Zepto ($) ->
	class Statusboard.Views.Stream extends Backbone.UnbindingView
		id: "stream"

		initialize: ->
			_.bindAll @, "render"

			@bindings = Statusboard.State.bindings
			@bindTo @collection, "reset add", @render
			@child_views = []

		render: ->
			child_views = @child_views

			@$el.children().empty().remove()

			$view = @$el

			for item in @collection
				console.log item

				stream_item = new Statusboard.Views.StreamItem
					model: item
				child_views.push stream_item

				$stream_item = $(stream_item.render().el)

				$view.prepend $stream_item

			@
