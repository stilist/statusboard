Handlebars?.registerHelper "highlight_hashtag", (item, options) ->
	pat = new RegExp("(##{Statusboard.State.hashtag})", "g")

	new Handlebars.SafeString item.replace(pat, "<span class='hashtag'>$1</span>")
