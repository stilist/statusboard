Zepto ($) ->
	class Statusboard.Collections.Items extends Backbone.Collection
		url: "/stories"
		parse: (data) -> data.story
		comparator: (model) -> new Date(model.get("timestamp")).getTime()

	Statusboard.Collections.items = new Statusboard.Collections.Items()
