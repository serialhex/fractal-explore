# awsum fractal explorer program!!
# by serialhex

File.open('log', 'a') do |f|
  f.puts "starting..."
end

require 'gosu'
require 'texplay'

require_relative 'fractal'
require_relative 'fadetext'

File.open('log', 'a') do |f|
  f.puts "done with require..."
end
 

class GameWindow < Gosu::Window

  def initialize width, height
    super width, height, false, 200
    self.caption = "Fractal Explorer of Awsumness!!"
    
    puts 'setting up the fractal & text'
    @fractal = Fractal.new self
    @text = FadeText.new self
    
  end
  
  attr_reader :offset, :magnification
  
  def update
    case # just in case :P
    when button_down?( Gosu::Button::KbDown )
      @fractal.move_down
    when button_down?( Gosu::Button::KbUp )
      @fractal.move_up
    when button_down?( Gosu::Button::KbLeft )
      @fractal.move_left
    when button_down?( Gosu::Button::KbRight )
      @fractal.move_right
    when button_down?( Gosu::Button::KbNumpadAdd )
      @fractal.zoom_in
    when button_down?( Gosu::Button::KbNumpadSubtract )
      @fractal.zoom_out
    else
      @fractal.update
    end
  end
  
  def draw
    @fractal.draw
    # @text.draw "mag: #{@fractal.mag}, coords: #{@fractal.center}, iterations: #{@fractal.iter} Zn: #{@fractal.zee_enn}"
    @text.draw "center: #{@fractal.px_to_com self.width*0.5, self.height*0.5 } coords: #{@fractal.center}, iterations: #{@fractal.iter}"
  end
  
end

File.open('log', 'a') do |f|
  f.puts "making window..."
end
# lets get this party started!!
window = GameWindow.new 640, 480
File.open('log', 'a') do |f|
  f.puts "starting window..."
end
window.show