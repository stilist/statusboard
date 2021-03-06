#= require ./boot
#= require_tree ./models
#= require_tree ./collections
#= require_tree ./views
#= require_tree ../../../templates/apps/weather

window.Weather =
	Collections: {}
	Models: {}
	Views: {}
	Routers: {}
	State: {}
	Meta:
		ApplicationName: "Weather"
		AuthorName: "Jordan Cole"
		AuthorURL: "http://ratafia.info"
		IconPath: ""
		Platforms:
			Mobile: false
			Desktop: true
		Type: "application"
		Version: 1.0
