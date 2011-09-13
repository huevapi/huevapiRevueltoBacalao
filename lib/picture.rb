require 'open-uri'
require 'mini_magick'
require 'nokogiri'

class Picture

  def self.get_size(url)
    begin
      MiniMagick::Image.open(url).identify.split(" ")[2].split("x")
    rescue
      puts "Error al obtener la imagen"
    end
  end

  def self.get_image_url(servicio, page_url)
    begin
      case servicio
        when 'twitpic': Nokogiri::HTML(open(page_url)).at_css("#photo-display")['src']
        when 'yfrog': Nokogiri::HTML(open(page_url)).at_css("#main_image")['src']
      end
    rescue
      puts "Error al descargar HTML de pagina de imagen"
    end
  end

end

