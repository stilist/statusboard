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

		# https://github.com/janko-m/sinatra-activerecord
		set :database, ENV["HEROKU_POSTGRESQL_PINK_URL"] || ENV["DATABASE_URL"] || ""
		puts "Using database: #{ENV["HEROKU_POSTGRESQL_PINK_URL"] || ENV["DATABASE_URL"] || ""}"
	end

	get "/" do
		erb "", :layout_engine => :haml
	end

	get "/stories" do
		content_type "application/json"

		fake_data = {
			service: settings.backend_apps.sample,
			username: random_string(20).gsub(/\s+/, ""),
			real_name: random_string(25),
			remote_image_url: random_image,
			comment: random_comment,
			timestamp: Time.now.iso8601,
			image: random_image,
			avatar: random_avatar,
			permalink: ""
		}

		story = Story.new fake_data

		if story.save
			puts " * saved"
		else
			story.errors.each { |k,v| puts " * #{k}: #{v}" }
		end

		puts
		puts "** Transmitted data (#{Time.now.iso8601})"
		puts story.to_json

		body story.to_json
	end

	private

	# http://stackoverflow.com/a/88341/672403
	def random_string max_length=50
		length = rand max_length

		characters = [" ", " ", " ", " ", ".", "!"]
		characters << ("a".."z").to_a
		characters << ("A".."Z").to_a
		(0...length).map { characters.flatten.sample }.join
	end

	def random_avatar
		images = [
			"http://images.instagram.com/profiles/profile_9396960_75sq_1315883516.jpg",
			"http://twimg0-a.akamaihd.net/profile_images/562360154/gorpic1209.png",
			"http://twimg0-a.akamaihd.net/profile_images/966149353/c867b0ac-574a-49fb-bb76-cce37fdad322.png"
		]

		include_image = rand(25) != 1

		include_image ? images.sample : ""
	end

	def random_image
		images = [
			"http://sphotos-b.xx.fbcdn.net/hphotos-snc6/196132_10151010546580102_1581486358_n.jpg",
			"http://distilleryimage0.s3.amazonaws.com/fa261eceb77f11e19894123138140d8c_7.jpg",
			"http://distilleryimage6.s3.amazonaws.com/31e6e75cb78111e1a8761231381b4856_7.jpg",
			"http://distilleryimage9.s3.amazonaws.com/6782376eb8c511e18cf91231380fd29b_7.jpg",
			"http://sphotos-a.xx.fbcdn.net/hphotos-snc7/s720x720/305429_10150423159500102_1992348656_n.jpg"
		]

		include_image = rand(3) != 1

		include_image ? images.sample : ""
	end

	def random_comment
		hashtag = "weaver2gorman"
		length = 140 - hashtag.length - 3

		comment = random_string length

		offset = rand (comment.length - 1)
		comment.insert offset, " ##{hashtag} "
	end
end
