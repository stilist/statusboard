class StoryImageUploader < CarrierWave::Uploader::Base
	storage :fog
end