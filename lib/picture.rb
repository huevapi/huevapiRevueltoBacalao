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

  def self.get_image_url(page_url)
    begin
      Nokogiri::HTML(open(page_url)).at_css("#photo-display")['src']
    rescue
      puts "Error al descargar HTML de página de imagen"
    end
  end

end

