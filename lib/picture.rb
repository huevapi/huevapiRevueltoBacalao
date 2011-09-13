require 'mini_magick'

class Picture

  def self.get_size(url)
    begin
      MiniMagick::Image.open(url).identify.split(" ")[2].split("x")
    rescue
      puts "Fallo al obtener la imagen"
    end
  end

end

