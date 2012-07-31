class Story < ActiveRecord::Base
	# validates_presence_of :service, :username, :real_name, :avatar, :permalink,
	# 		:comment

	mount_uploader :image, StoryImageUploader
end
