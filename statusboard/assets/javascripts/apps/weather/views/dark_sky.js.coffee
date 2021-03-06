jQuery ($) ->
	class Weather.Views.DarkSky extends Backbone.UnbindingView
		tagName: "section"
		id: "dark_sky"

		initialize: ->
			_.bindAll @, "render", "_draw_sparkline"

			@bindings = Weather.State.bindings
			@bindTo @collection, "reset", @render
			@child_views = []

		_calculate_min_max: (items) ->
			_min = []
			_max = []

			_.each items, (item) ->
				_min.push (item.intensity - item.error)
				_max.push (item.intensity + item.error)

			[_min, _max]

		_draw_sparkline: (data, selector) ->
			_base_options =
				chartRangeMax: 75
				chartRangeMin: 0
				disableHighlight: true
				disableTooltips: true
				height: "100%"
				lineColor: false
				maxSpotColor: false
				minSpotColor: false
				spotColor: false
				type: "line"
				width: "100%"
			_max_options = $.extend {}, _base_options,
				fillColor: "rgba(92, 114, 135, 0.5)"
			_min_options = $.extend {}, _base_options,
				composite: true
				fillColor: "rgba(119, 127, 135, 0.5)"

			[_min, _max] = @_calculate_min_max data

			@$el.find(selector).sparkline _max, _max_options
			@$el.find(selector).sparkline _min, _min_options

		render: ->
			collection = @collection
			child_views = @child_views

			@$el.children().empty().remove()
			$view = @$el

			_sparkline = @_draw_sparkline

			collection.each (item) ->
				forecast = new Weather.Views.DarkSkyForecast
					collection: collection
					model: item

				$view.append forecast.render().el
				child_views.push forecast

				# Trying to render the sparkline in `Weather.Views.dark_sky_forecast`
				# fails because the view hasn't been inserted yet.
				_sparkline item.get("hourPrecipitation"), ".forecast.next_hour"

			@
