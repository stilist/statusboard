class StatusboardApp < Sinatra::Base
	register Sinatra::Synchrony
	register Sinatra::StaticAssets
	register Sinatra::ActiveRecordExtension

	require File.expand_path(File.join(File.dirname(__FILE__), "story_image_uploader.rb"))
	require "carrierwave/orm/activerecord"

	# database models
	require File.expand_path(File.join(File.dirname(__FILE__), "models.rb"))

	# for generating timestamp in `fake_data`
	require "time"

	# http://stackoverflow.com/a/4525933/672403
	configure do
		set :backend_apps, %w(foursquare instagram twitter)

		set :hashtag, ENV["HASHTAG"] || ""

		# https://github.com/janko-m/sinatra-activerecord
		database_url = ENV["HEROKU_POSTGRESQL_PINK_URL"] || ENV["DATABASE_URL"] || ""
		set :database, database_url
		puts " * Using database: #{database_url}"

		# kill `:story => { … }` on serialized `Story` rows
		ActiveRecord::Base.include_root_in_json = false
	end

	get "/" do
		erb "", :layout_engine => :haml
	end

	get "/twitter" do
		items = Twitter.search(settings.hashtag, :include_entities => true).results

		items.each do |item|
			data = {
				service: "twitter",
				username: item.from_user,
				real_name: item.from_user_name,
				comment: item.text,
				timestamp: item.created_at,
				avatar: item.profile_image_url,
				permalink: "http://twitter.com/#{item.from_user}/#{item.id}",
				original_id: item.id
			}

			# TODO handle photo booth
			# https://github.com/wtm/statusboard/blob/wtmisfive/statusboard/assets/javascripts/apps/twitter/collections/items.js.coffee
			unless item.media.empty?
				data.merge!({ :remote_image_url => item.media.first[:media_url] })
			end

			save_story data
		end

		erb ""
	end

	get "/photo_booth" do
	end

	get "/instagram" do
		items = Instagram.tag_recent_media settings.hashtag

		items["data"].each do |item|
			data = {
				service: "instagram",
				username: item[:user][:username],
				real_name: item[:user][:full_name],
				remote_image_url: item[:images][:standard_resolution][:url],
				comment: (item[:caption] && item[:caption][:text]) ? item[:caption][:text] : "",
				timestamp: Time.at(item[:created_time].to_i),
				avatar: item[:user][:profile_picture],
				permalink: item[:link],
				original_id: item[:id]
			}

			save_story data
		end

		erb ""
	end

	get "/stories" do
		content_type "application/json"

		stories = Story.limit(10).order("timestamp ASC").all

		puts
		puts "** Transmitted at #{Time.now.iso8601}"

		body stories.to_json
	end

	private

	def save_story data = {}
		story = Story.new data

		existing = Story.where(:service => story.service)
				.where(:original_id => story.original_id.to_s).all

		if existing.empty?
			if story.save
				puts " * saved"
			else
				story.errors.each { |k,v| puts "   #{k}: #{v}" }
			end
		else
			puts " * existing"
		end
	end
end
