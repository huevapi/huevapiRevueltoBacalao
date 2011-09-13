require 'open-uri'
require 'mini_magick'
require 'nokogiri'
require 'json'

class Picture

  def self.get_size(url)
    begin
      MiniMagick::Image.open(url).identify.split(" ")[2].split("x")
    rescue
      puts "Error al obtener la imagen"
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

