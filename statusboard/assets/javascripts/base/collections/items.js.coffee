Zepto ($) ->
	class Statusboard.Collections.Items extends Backbone.Collection
		url: "/stories"
		comparator: (model) -> new Date(model.get("timestamp")).getTime()

	Statusboard.Collections.items = new Statusboard.Collections.Items()
