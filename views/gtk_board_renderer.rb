require 'gtk2'

class GtkBoardRenderer < Gtk::Window
  SQUARE_WIDTH = 32

  attr_reader :board

  def initialize(board)
    super("Chesticles")

    @board = board

    set_default_size(SQUARE_WIDTH*8, SQUARE_WIDTH*8)

    signal_connect("expose-event") do |widget, event|
      gc = Gdk::GC.new(widget.window)
      render(gc, widget.window)
    end

    signal_connect('button_press_event') do |widget, event|
      x = (event.x / SQUARE_WIDTH).floor
      y = (event.y / SQUARE_WIDTH).floor
      s = Square.new(x,y)
      square_clicked(s)
    end

    add_events(Gdk::Event::BUTTON_PRESS_MASK)

    setup_colors
    show_all.signal_connect("destroy"){Gtk.main_quit}
    Gtk.main
  end

  def setup_colors
    @white = Gdk::Color.new(65535, 65535, 65535)
    @black = Gdk::Color.new(40000, 40000, 40000)
    @selected_square_color = Gdk::Color.parse("orange")
    colormap = Gdk::Colormap.system
    colormap.alloc_color(@white, false, true)
    colormap.alloc_color(@black, false, true)
    colormap.alloc_color(@selected_square_color, false, true)
  end

  def render(gc, drawable)
    draw_board(gc, drawable)
  end

  def draw_board(gc, drawable)

    0.upto(7) do |x|
      0.upto(7) do |y|
        s = Square.new(x,y)

        color = if @selected_square && s == @selected_square
          @selected_square_color
        elsif s.black?
          @black
        else
          @white
        end
        gc.set_foreground(color)


        drawable.draw_rectangle(gc, true, x*SQUARE_WIDTH, y*SQUARE_WIDTH, SQUARE_WIDTH, SQUARE_WIDTH)

        if p = board.piece_for(s)
          pix_buf = pixbuf_for(p)
          drawable.draw_pixbuf(gc, pix_buf, 0,0,   x*SQUARE_WIDTH,y*SQUARE_WIDTH,  SQUARE_WIDTH,SQUARE_WIDTH, Gdk::RGB::DITHER_NORMAL,   0,0)
        end
      end
    end
  end

  def square_clicked(square)
    if @selected_square.nil?
      @selected_square = square if @board.piece_for(square)
    else
      begin
        @board.piece_for(@selected_square).move_to(square)
      rescue Piece::IllegalMoveError
      end
      @selected_square = nil
    end
    queue_draw
  end

  def pixbuf_for(piece)
    image_file = piece.class.to_s.downcase + ".gif"
    color = piece.white? ? "white" : "black"
    pix_buf = Gdk::Pixbuf.new("data/piece_images/#{color}/#{image_file}")
  end

end
