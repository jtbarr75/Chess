require_relative 'piece.rb'
require_relative 'square.rb'

class Board
  attr_reader :grid

  WHITE = " "
  BLACK = " "
  
  def initialize
    @grid = create_blank_board
    create_starting_board
  end

  #Create a 8x8 grid of alternating black and white squares, sets those as default for when there's no piece on a square
  def create_blank_board
    grid = []
    8.times do |i|
      white, black = [], []
      4.times { white << Square.new(WHITE) }
      4.times { black << Square.new(BLACK) }
      line = i%2 == 0 ? black.zip(white).flatten : white.zip(black).flatten
      grid << line
    end
    grid
  end

  #places pieces on board in their initial positions
  def create_starting_board
    #place first and last row
    ["Castle","Knight","Bishop","Queen","King","Bishop","Knight","Castle"].each_with_index do |piece, col|
      place_piece(Piece.const_get(piece).new('black', [0,col], self), [0,col])
      place_piece(Piece.const_get(piece).new('white', [7,col], self), [7,col])
    end
    #place pawn rows
    8.times do |col|
      place_piece(Pawn.new('black', [1, col], self), [1, col])
      place_piece(Pawn.new('white', [6, col], self), [6, col])
    end
  end

  #Prints the grid
  def print_grid
    alternate = false
    grid.each do |row|
      alternate = !alternate
      row.map(&:to_s).each_with_index do |icon, index|
        if alternate
          print "#{index%2 == 0 ? colorize("#{icon} ", 'black', 'white') : colorize("#{icon} ", 'black', 'dark gray')}"
        else
          print "#{index%2 == 0 ? colorize("#{icon} ", 'black', 'dark gray') : colorize("#{icon} ", 'black', 'white')}"
        end
      end
      print "\n"
    end
  end

  def place_piece(piece, location)
    row = location[0]
    col = location[1]
    @grid[row][col].current = piece
  end

  def colorize(text, color = "default", bgColor = "default")
    colors = {"default" => "38","black" => "30", "gray" => "37", "dark gray" => "1;30", "white" => "1;37"}
    bgColors = {"default" => "0", "black" => "40", "gray" => "47", "dark gray" => "100", "white" => "107"}
    color_code = colors[color]
    bgColor_code = bgColors[bgColor]
    return "\033[#{bgColor_code};#{color_code}m#{text}\033[0m"
  end
end

# board = Board.new
# board.print_grid