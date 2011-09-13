class ImageRelevanceController < ApplicationController
	def list
		images = RelevantImage.order('created_at desc')
		render :json => {:image_count => images.count, :images => images}.to_json, :layout => false, :content_type => 'text/json'
	end
end
