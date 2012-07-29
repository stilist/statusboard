source :rubygems

gem "rake"
gem "thin"

group :statusboard_app do
	# server
	gem "sinatra", :require => "sinatra/base"
	gem "sinatra-synchrony", :require => "sinatra/synchrony"
	gem "sinatra-static-assets", :require => "sinatra/static_assets"

	# database
	gem "sinatra-activerecord", :require => "sinatra/activerecord"
	gem "pg"

	# services
	gem "foursquare2"

	# HTML5 cache manifest
	gem "rack-offline", :require => "rack/offline"

	# content types
	gem "sprockets"
	gem "coffee-script"
	gem "sprockets-helpers", "~> 0.2"
	gem "sprockets-sass", "~> 0.5"
	gem "sass"

	# Handlebars + HAML, as templates
	gem "hamlbars"
end
