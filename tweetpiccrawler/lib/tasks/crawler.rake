require 'net/http'
require 'uri'
require 'json'
require 'nokogiri'
require 'mini_magick'
require 'open-uri'

def clean_url(uri_str, limit = 10)
	raise ArgumentError, 'HTTP redirect too deep' if limit == 0
	response = Net::HTTP.get_response(URI.parse(uri_str))
	case response
	when Net::HTTPSuccess     then uri_str
	when Net::HTTPRedirection then clean_url(response['location'], limit - 1)
	else
		response.error!
	end
end

class Picture

  def self.get_size(url)
    begin
      MiniMagick::Image.open(url).identify.split(" ")[2].split("x")
    rescue
     # puts "Error al obtener la imagen"
    end
  end

  def self.get_image_url(page_url)
    begin
      if page_url.match('twitpic.com')
        return Nokogiri::HTML(open(page_url)).at_css("#photo-display")['src']
      elsif page_url.match('yfrog.com')
        return Nokogiri::HTML(open(page_url)).at_css("#main_image")['src']
      elsif page_url.match('imgur.com')
        return page_url
      elsif page_url.match('twitter.com')
        id = page_url.match(/status\/([^\/]*)\//)[1]
        json = JSON.parse(open("http://api.twitter.com/1/statuses/show.json?include_entities=true&id=#{id}").read)
        return json["entities"]["media"][0]["media_url"]
      end
    rescue
      puts "Error al descargar HTML de pagina de imagen"
    end
  end

end

namespace :crawler do
	
	desc "Parse data from twitter"
	task :crawl => :environment do
		
		#sacar los datos de twitter
		res = Net::HTTP.get(URI.parse('http://search.twitter.com/search.json?q=@cnnchile%20twitpic.com&result_type=mixed&rpp=30'))
 		json_data = JSON.parse(res)
		possible_urls = []
		usernames = []
		tweet_ids = []
		json_data['results'].collect {|tweet| tweet_ids << tweet['id_str'];usernames << tweet['from_user']; possible_urls << tweet['text'].match(/http:\/\/[\w.\/]*/)[0] }
		
		image_services = []
		
		clean_usernames = []
		clean_tweet_ids = []
		possible_urls.each do |url|
			url_clean = clean_url url
			unless url_clean.match(/twitpic.com|imgur.com|yfrog.com|pic.twitter.com/).nil?
					clean_usernames << usernames[possible_urls.index(url)]
					clean_tweet_ids << tweet_ids[possible_urls.index(url)]
					image_services << url_clean 
			end 
		
		end
		
		images_url = image_services.collect do |service_url| 
			Picture.get_image_url service_url
		end
		
		image_sizes = images_url.collect {|image| Picture.get_size(image)}
		
		clean_usernames.count.times do |i|
			RelevantImage.create(:username => clean_usernames[i], :relevance_count => rand(10) + 1, 
				:image_url => images_url[i], :posted_at => DateTime.now, 
				:image_width => image_sizes[i][0], :image_height => image_sizes[i][1], 
				:tweet_url => "http://twitter.com/#!/#{clean_usernames[i]}/status/#{clean_tweet_ids[i]}")
		end
		
		#image_services.collect do |service_url| 
		#	Picture.get_image_url service_url
		#end

	end
	
end