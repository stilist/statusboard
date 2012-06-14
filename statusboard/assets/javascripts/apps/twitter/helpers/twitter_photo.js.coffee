Handlebars?.registerHelper "twitter_photo", (items, options) ->
	console.log "photos", items

	unless items.length is 0
		photo = _.first items

		new Handlebars.SafeString "<span class='image' style='background-image:url(#{photo.media_url});'></span>"
	else
		""