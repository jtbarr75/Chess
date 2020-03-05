require_relative 'piece.rb'

class Board
  attr_reader :grid

  WHITE = " "
  BLACK = " "
  
  def initialize
    @grid = Array.new(8) { Array.new(8, nil) }
    create_starting_board
    @black_king = self.at(0, 4)
    @white_king = self.at(7, 4)
  end

  #places pieces on board in their initial positions
  def create_starting_board
    #place first and last row
    ["Castle","Knight","Bishop","Queen","King","Bishop","Knight","Castle"].each_with_index do |piece, col|
      @grid[0][col] = Piece.const_get(piece).new('black', [0,col], self)
      @grid[7][col] = Piece.const_get(piece).new('white', [7,col], self)
    end
    #place pawn rows
    8.times do |col|
      @grid[1][col] = Pawn.new('black', [1, col], self)
      @grid[6][col] = Pawn.new('white', [6, col], self)
    end
  end

  #Prints the grid
  def print_grid
    puts "  A B C D E F G H"
    alternate = 1
    grid.each_with_index do |row, index|
      print "#{8 - index} "
      row.each_with_index do |icon, index|
        if icon.nil?
          print "#{index%2 == alternate ? colorize("  ", 'white') : colorize("  ", 'dark gray')}"
        else
          print "#{index%2 == alternate ? colorize("#{icon} ", 'white') : colorize("#{icon} ", 'dark gray')}"
        end
        
      end
      alternate == 0 ? alternate = 1 : alternate = 0
      print " #{8 - index}"
      print "\n"
    end
    puts "  A B C D E F G H"
  end

  def place_piece(piece, location)
    row = location[0]
    col = location[1]
    @grid[row][col] = piece
    @grid[piece.row][piece.col] = nil
    piece.set_location(location)
  end

  def colorize(text, bgColor = "default")
    colors = {"default" => "38","black" => "30", "gray" => "37", "dark gray" => "1;30", "white" => "1;37"}
    bgColors = {"default" => "0", "black" => "40", "gray" => "47", "dark gray" => "100", "white" => "107"}
    color_code = colors['black']
    bgColor_code = bgColors[bgColor]
    return "\033[#{bgColor_code};#{color_code}m#{text}\033[0m"
  end

  def at(row, col)
    grid[row][col] if row.between?(0, 7) && col.between?(0, 7)
  end

  #returns locations of white or black pieces that have moves available
  def pieces_with_moves(white_turn)
    grid.flatten.select do |piece|
      piece.is_a?(Piece) && piece.color == (white_turn ? 'white' : 'black') && piece.valid_locations != []
    end.map { |piece| [piece.row, piece.col] }
  end

  #returns array of white pieces on the board
  def white_pieces
    grid.flatten.select{ |piece| piece.is_a?(Piece) && piece.color == 'white' }
  end

  #returns array of black pieces on the board
  def black_pieces
    grid.flatten.select{ |piece| piece.is_a?(Piece) && piece.color == 'black' }
  end

  def black_check?(king_row = @black_king.row, king_col = @black_king.col)
    threatened_locations = []
    self.white_pieces.each do |piece|
      threatened_locations << piece.valid_locations 
    end
    if threatened_locations.flatten(1).include?([king_row, king_col])
      return true
    end
    false
  end

  def white_check?(king_row = @white_king.row, king_col = @white_king.col)
    threatened_locations = []
    self.black_pieces.each do |piece|
      threatened_locations << piece.valid_locations
    end
    if threatened_locations.flatten(1).include?([king_row, king_col])
      return true
    end
    false
  end

  def black_checkmate?
    if black_check?
      return true if @black_king.valid_locations == []
      puts @black_king.valid_locations
      return @black_king.valid_locations.all? { |location| black_check?(location[0], location[1]) }
    end
    false
  end

  def white_checkmate?
    if black_check?
      return @white_king.valid_locations.all? { |location| white_check?(location[0], location[1]) }
    end
    false
  end
end

# board = Board.new
# board.print_grid