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
		%w(dedicated_twitter_username hashtag).each do |setting|
			value = ENV[setting.upcase] || ""
			set setting.to_sym, value
			puts " * Using #{setting}: #{value}"
		end

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

	# Hack for service polling
	get "/fetch" do
		erb "", :layout_engine => :haml
	end

	get "/photobooth" do
		puts "** Photo booth"

		items = Twitter.user_timeline(settings.dedicated_twitter_username,
				:count => 200, :include_entities => true)

		parse_tweets items

		content_type "application/json"
		body "{}"
	end

	get "/twitter" do
		puts "** Polling Twitter"

		items = Twitter.search(settings.hashtag, :include_entities => true).results

		parse_tweets items

		content_type "application/json"
		body "{}"
	end

	get "/instagram" do
		puts "** Polling Instagram"

		items = Instagram.tag_recent_media settings.hashtag

		puts " * #{items["data"].length} items (Instagram)"

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

		content_type "application/json"
		body "{}"
	end

	get "/stories" do
		stories = Story.limit(10).order("timestamp DESC, id DESC").all

		puts
		puts "** Transmitted at #{Time.now.iso8601}"

		content_type "application/json"
		body stories.to_json
	end

	private

	def parse_tweets items = []
		puts " * #{items.length} items (Twitter)"

		items.each do |item|
			data = {
				service: "twitter",
				comment: item.text,
				timestamp: item.created_at,
				avatar: item.profile_image_url,
				permalink: "http://twitter.com/#{item.from_user}/#{item.id}",
				original_id: item.id
			}

			# Search results use a different format
			if item[:from_user]
				puts "------- search"
				user = {
					username: item.from_user,
					real_name: item.from_user_name
				}
			else
				puts "----------- timeline"
				puts item[:user].inspect
				user = {
					username: item[:user][:screen_name],
					real_name: item[:user][:name]
				}
			end
			puts "-_L#ILIF user:"
			puts user
			data.merge!(user)

			if item.media.empty?
				# https://github.com/stilist/statusboard/blob/wtmisfive/statusboard/assets/javascripts/apps/twitter/collections/items.js.coffee
				if item.from_user == settings.dedicated_twitter_username
					if item.urls && !item.urls.empty? && item.urls[0].expanded_url
						data.merge!({ :remote_image_url => item.urls[0].expanded_url })
					end
				end
			else
				data.merge!({ :remote_image_url => item.media.first[:media_url] })
			end

			save_story data
		end
	end

	def save_story data = {}
		story = Story.new data

		existing = Story.where(:service => story.service)
				.where(:original_id => story.original_id.to_s).all

		if existing.empty?
			unless story.save
				puts " * Didn't save because:"
				story.errors.each { |k,v| puts "   #{k}: #{v}" }
			end
		end
	end
end
