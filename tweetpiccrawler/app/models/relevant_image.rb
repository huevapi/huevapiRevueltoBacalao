class RelevantImage < ActiveRecord::Base
	
	def as_json(options = {})
		json = {}
		json[:image_width] = self.image_width
		json[:image_height] = self.image_height
		json[:image_url] = self.image_url
		json[:username] = self.username
		json[:tweet_url] = self.tweet_url
		json[:relevance_count] = self.relevance_count
		json
	end
	
end
