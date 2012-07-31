class AddOriginalIdToStories < ActiveRecord::Migration
	def up
		add_column :stories, :original_id, :string
	end

	def down
		drop_column :stories, :original_id
	end
end
