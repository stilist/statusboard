class CreateStories < ActiveRecord::Migration
	def up
		create_table :stories do |t|
			t.string :service, :null => false, :default => ""
			t.string :username, :null => false, :default => ""
			t.string :real_name, :null => false, :default => ""
			t.datetime :timestamp
			t.string :avatar, :null => false, :default => ""
			t.string :permalink, :null => false, :default => ""
			t.text :comment, :null => false, :default => ""
		end
	end

	def down
		drop_table :stories
	end
end
