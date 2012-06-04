jQuery ($) ->
	class Weather.Views.WundergroundForecast extends Backbone.View
		tagName: "section"
		className: "item"
		template: Handlebars.templates["apps/weather/wunderground_forecast"]

		initialize: ->
			_.bindAll @, "render"

		render: ->
			@$el.html @template @model.toJSON()

			console.log @model.toJSON()

			@