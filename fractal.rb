
require 'mathn'
require 'complex'


class Fractal
  
  # accessors, readers & riterz!
  attr_accessor :max_iter
  attr_reader :center, :iter
  
  def mag
    return @mag_fact ** -@mag
  end
  
  def initialize window, max_iter = 50
    @window =  window
    @max_iter = max_iter
    
    @image = TexPlay.create_blank_image @window, @window.width, @window.height
    # add this later
    # @image2 = @image.dup
    
    # initialize sheat!
    @fractaling = false
    @center = Complex( -0.75, 0.0 )
    @mag = 0
    @mag_fact = 2
    
    set_vars
  end
  
  # sets the fractalling in motion and ensures that things go smoothly.
  # will probably add more functionality - like switching between mandelbrot &
  # julia sets in here sometime later...
  def update
    catch :stop_fract do
      @fractaling = true
      unless @iter == @max_iter
        do_fract
      end
    end
  ensure
    @fractaling = false
  end
  
  # sets up the basic variables for the computation
  def set_vars
    throw :stop_fract if @fractaling
    @image.rect 0, 0, @window.width, @window.height, :color => :black, :fill => true
    @image_hash = {}
    @window.width.times do |x|
      @image_hash[x] = {}
      @window.height.times do |y|
        @image_hash[x][y] = Complex( 0.0, 0.0)
      end
    end
    @iter = 0
  end
  
  # the main fractalling function... called by update to accually do the work
  def do_fract
    @iter += 1
    @image_hash.each do |x, y_hsh|
      y_hsh.each do |y, val|
        k = px_to_com x, y
        zn = @image_hash[x][y]
        zn = zn**2 + k
        @image_hash[x][y] = zn
        if (zn.abs2 >= 4.0) or (@iter == @max_iter)
          # colorize!
          if @iter == @max_iter
            @image.pixel x, y, :color => [ 0.5, 0.0, 0.0, 1.0 ]
          else
            v = (@iter - Math::log(Math::log(zn.abs))/Math::log(2) )/@max_iter
            r = @iter / @max_iter
            g = v
            b = Math::log(@iter)/Math::log(@max_iter)
            a = 1.0
            @image.pixel x, y, :color => [ r, g, b, a ]
          end
          @image_hash[x].delete y
        end
      end
    end
  end
  
  # takes pixel coords & gives a Complex number based on current window
  # sets 100px = 1u on the complex plane
  def px_to_com x, y
    # make it complex to work with :P
    z = Complex x.to_f, y.to_f
    z = ((z - Complex(@window.width*0.5, @window.height*0.5))*0.005 ).conjugate
    return (z + @center) * @mag_fact ** @mag
  end
  
  # theres prolly a neato metaprogramming way to do this...
  # but ima do it manually for now :P
  def move_up
    @center += Complex( 0, 0.1)* @mag_fact ** @mag
    set_vars
  end
  def move_down
    @center += Complex( 0, -0.1)* @mag_fact ** @mag
    set_vars
  end
  def move_left
    @center += Complex( -0.1, 0)* @mag_fact ** @mag
    set_vars
  end
  def move_right
    @center += Complex( 0.1, 0)* @mag_fact ** @mag
    set_vars
  end
  def zoom_in
    @mag -= 1
    set_vars
  end
  def zoom_out
    @mag += 1
    set_vars
  end
  
  def draw
    # when doing magnification, do something like this:
    # @image2.draw_rot <stuff below & figure out offset>, 0.5, 0.5, 10, 10 <- thoes last 2 are imp!!!
    # when i get it spiffy i can do some soft zooming shit with it!!!
    # and some cool colorizing too!!!
    @image.draw_rot @window.width*0.5, @window.height*0.5, 0, 0
  end
end
