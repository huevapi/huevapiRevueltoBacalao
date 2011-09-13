class RelevantImage < ActiveRecord::Base
	
	def as_json(options = {})
		json = {}
		json[:width] = self.image_width
		json[:height] = self.image_height
		json[:url] = self.image_url
		#json[:username] = self.username
		json[:link_url] = self.tweet_url
		json[:weight] = self.relevance_count % 10
		json
	end
	
end
