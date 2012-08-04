namespace :db do
	task :fix_twitter_permalinks
		items = Story.where(:service_name => "twitter").all
		items.all.each do |item|
			item.permalink = "http://twitter.com/#{item.from_user}/statuses/#{item.id}"
			item.save
		end
	end
end
