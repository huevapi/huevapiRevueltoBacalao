require 'mini_magick'

class Picture

  def self.get_size(url)
    MiniMagick::Image.open(url).identify.split(" ")[2].split("x")
  end

end

