Zepto ($) ->
	class Statusboard.Routers.Main extends Backbone.Router
		routes:
			"": "index"
			"fetch": "poller"

		index: ->
			Statusboard.Collections.items.fetch()

			wrapper = new Statusboard.Views.Main
				collection: Statusboard.Collections.items

			$(document.body).append wrapper.render().el

		# Hack for service polling
		poller: ->
			_fetch = ->
				$.getJSON "/twitter"
				$.getJSON "/instagram"

			setInterval _fetch, Statusboard.State.autorefresh_delay

	window.StatusboardApp = new Statusboard.Routers.Main()
