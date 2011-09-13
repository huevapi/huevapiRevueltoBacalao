class ImageRelevanceController < ApplicationController
	def list
		images = RelevantImage.all
		render :json => {:images => images}.to_json, :layout => false, :content_type => 'text/json'
	end
end
