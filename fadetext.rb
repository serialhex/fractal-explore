class FadeText
  def initialize window, fade_time = 5.0
    @window = window
    @fade_time = fade_time
    
    @image = Gosu::Font.new @window, Gosu.default_font_name, 20
    @color = 0xffffffff
    
  end
  
  def update
    # implement cool fading technology!!
  end
  
  def draw text
    update
    @image.draw text, 0, (@window.height - 40), 1, 1, 1, @color
  end
  
end
