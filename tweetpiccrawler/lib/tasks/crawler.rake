require 'net/http'
require 'uri'
require 'json'

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

namespace :crawler do
	
	desc "Parse data from twitter"
	task :crawl => :environment do
		
		#sacar los datos de twitter
		res = Net::HTTP.get(URI.parse('http://search.twitter.com/search.json?q=@biobio%20twitpic.com&result_type=mixed&rpp=3'))
 		json_data = JSON.parse(res)
		possible_urls = []
		json_data['results'].collect {|tweet| tweet['text'].match(/http:\/\/[\w.\/]*/).to_a.each{|url| possible_urls << url} }
		
		#possible_urls = ["http://t.co/Qt3F8W3", "http://bit.ly/py4F6p"]
		#asumir que tengo un arreglo de urls
		
		image_services = []
		
		possible_urls.each do |url|
			url_clean = clean_url url
			image_services << url_clean unless url_clean.match(/twitpic.com|imgur.com|yfrog.com|pic.twitter.com/).nil?
		end
		
		puts image_services
		
		image_services.collect {|service_url| }
		
		#uri_str = "http://t.co/Qt3F8W3"
		#response = Net::HTTP.get_response(URI.parse(uri_str))
		#puts response
		#res = Net::HTTP.post_form(URI.parse(base_url + county_list_path),{})
		#counties = res.body.scan(/value="([\s\w]*)(?=")/).collect {|val| val.first.mixed_case}
	end
	
end