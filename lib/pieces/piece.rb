

class Piece
  attr_reader :name, :icon, :board, :color
  attr_accessor :row, :col

  ICONS = { king_white: "\u{2654}", king_black: "\u{265A}",
            queen_white: "\u{2655}", queen_black: "\u{265B}",
            bishop_white: "\u{2657}", bishop_black: "\u{265D}",
            knight_white: "\u{2658}", knight_black: "\u{265E}",
            castle_white: "\u{2656}", castle_black: "\u{265C}",
            pawn_white: "\u{2659}", pawn_black: "\u{265F}"}

  def initialize(color, pos, board)
    @color = color
    @row = pos[0]
    @col = pos[1]
    @board = board
    @icon = ICONS["#{self.class.name.downcase}_#{color}".to_sym]
  end

  def to_s 
    @icon
  end

  def set_location(loc)
    @row = loc[0]
    @col = loc[1]
  end

  def valid_locations
    moves = create_moves
    valid = []
    moves.each do |move|
      valid << [move[0] + row, move[1] + col]
    end
    valid
  end

  def create_moves
    []
  end

  #add every move to the left or right up to n spaces e.g. queen can move max 7 spaces
  def generate_horizontal_moves(n)
    moves = []
    (1..n).each do |i| 
      break if row + i > 7
      target = board.at(row + i, col)
      if target.is_a? Piece
        moves << [i, 0] unless target.color == self.color
        break
      else
        moves << [i,0]
      end
    end
    (1..n).each do |i| 
      break if row - i < 0
      target = board.at(row - i, col)
      if target.is_a? Piece
        moves << [-i, 0] unless target.color == self.color
        break
      else
        moves << [-i,0]
      end
    end
    moves
  end

  #add every move up and down up to n spaces e.g. queen can move max 7 spaces
  def generate_vertical_moves(n)
    moves = []
    (1..n).each do |i|
      break if col + i > 7
      target = board.at(row, col + i)
      if target.is_a? Piece
        moves << [0, i] unless target.color == self.color
        break
      else
        moves << [0,i]
      end
    end
    (1..n).each do |i|
      break if col - i < 0
      target = board.at(row, col - i)
      if target.is_a? Piece
        moves << [0, -i] unless target.color == self.color
        break
      else
        moves << [0, -i]
      end
    end
    moves 
  end

  #add every move diagonally up for max n spaces e.g. queen can move max 7 spaces
  def generate_diagonal_moves(n)
    moves = []
    (1..n).each do |i|
      break if row + i > 7 || col + i > 7
      target = board.at(row + i, col + i)
      if target.is_a? Piece
        moves << [i, i] unless target.color == self.color
        break
      else
        moves << [i, i]
      end
    end
    (1..n).each do |i|
      break if row + i > 7 || col - i < 0
      target = board.at(row + i, col - i)
      if target.is_a? Piece
        moves << [i, -i] unless target.color == self.color
        break
      else
        moves << [i, -i]
      end
    end
    (1..n).each do |i|
      break if row - i < 0 || col - i < 0
      target = board.at(row - i, col - i)
      if target.is_a? Piece
        moves << [-i, -i] unless target.color == self.color
        break
      else
        moves << [-i, -i]
      end
    end
    (1..n).each do |i|
      break if row - i < 0 || col + i > 7
      target = board.at(row - i, col + i)
      if target.is_a? Piece
        moves << [-i, i] unless target.color == self.color
        break
      else
        moves << [-i, i]
      end
    end
    moves
  end
end