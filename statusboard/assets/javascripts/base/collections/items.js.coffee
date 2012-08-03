Zepto ($) ->
	class Statusboard.Collections.Items extends Backbone.Collection
		url: "/stories"
		comparator: (model) -> new Date(model.get("timestamp")).getTime()

		add: (new_models, options) =>
			modelsToAdd = []

			# If a single model is passed in, convert it to an array so we can use
			# the same logic for both cases below.
			new_models = [new_models] unless _.isArray(new_models)

			_filter = (model) -> @get model.id
			modelsToAdd = _.reject new_models, _filter, @

			Backbone.Collection.prototype.add.call @, modelsToAdd, options

	Statusboard.Collections.items = new Statusboard.Collections.Items()
