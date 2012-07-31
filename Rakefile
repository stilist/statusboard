# https://github.com/janko-m/sinatra-activerecord
require "sinatra/activerecord/rake"

namespace :db do
	# Load gems
	require "rubygems"
	require "bundler"
	Bundler.require :statusboard_app

	# Load app
	require File.expand_path(File.join(File.dirname(__FILE__), "statusboard", "app.rb"))
end

desc "Run the server"
task :server do
	system "thin start -p 9010"
end
