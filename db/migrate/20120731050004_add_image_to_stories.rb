class AddImageToStories < ActiveRecord::Migration
	def up
		add_column :stories, :image, :string
	end

	def down
		drop_column :stories, :image
	end
end
