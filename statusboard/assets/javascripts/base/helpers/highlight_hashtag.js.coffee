Handlebars?.registerHelper "highlight_hashtag", (item, options) ->
	pat = new RegExp("(##{Statusboard.State.hashtag})", "g")

	if item?
		new Handlebars.SafeString item.replace(pat, "<span class='hashtag'>$1</span>")
	else
		""
