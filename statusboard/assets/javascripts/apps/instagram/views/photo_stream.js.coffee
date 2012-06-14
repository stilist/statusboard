jQuery ($) ->
	class Instagram.Views.PhotoStream extends Backbone.UnbindingView
		initialize: ->
			_.bindAll @, "render"

			@bindings = Instagram.State.bindings
			@bindTo @collection, "reset", @render
			@child_views = []

		render: ->
			collection = @collection
			child_views = @child_views

			$view = $("#stream")

			collection.each (item) ->
				photo = new Instagram.Views.Photo
					collection: collection
					model: item

				$view.append photo.render().el
				child_views.push photo

			@
