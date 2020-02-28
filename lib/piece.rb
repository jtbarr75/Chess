class Piece
  attr_reader :name, :icon
  attr_accessor :pos

  ICONS = { king_white: "\u{2654}", king_black: "\u{265A}",
            queen_white: "\u{2655}", queen_black: "\u{265B}",
            bishop_white: "\u{2657}", bishop_black: "\u{265D}",
            knight_white: "\u{2658}", knight_black: "\u{265E}",
            castle_white: "\u{2656}", castle_black: "\u{265C}",
            pawn_white: "\u{2659}", pawn_black: "\u{265F}" }

  def initialize(color, pos, board)
    @color = color
    @pos = pos
    @board = board
    @moves = create_moves
    @icon = @icon = ICONS["#{self.class.name.downcase}_#{color}".to_sym]
  end

  #each piece is initialized with all valid moves from their pos
  def create_moves
    valid_moves = []
    @moves.each do |move|
      pos = [move[0] + loc[0], move[1] + loc[1]]
      valid_moves << pos if pos[0].between?(0,7) && pos[1].between?(0,7)
    end
    valid_moves
  end

  def create_moves
    []
  end

  #add every move to the left and right for max n spaces e.g. queen can move max 7 spaces
  def generate_horizontal_moves(n)
    moves = []
    (1..n).each do |i|
      moves << [i, 0]
      moves << [-i, 0]
    end
  end

  #add every move up and down for max n spaces e.g. queen can move max 7 spaces
  def generate_vertical_moves(n)
    moves = []
    (1..n).each do |i|
      moves << [0, i]
      moves << [0, -i]
    end
  end

  #add every move diagonally for max n spaces e.g. queen can move max 7 spaces
  def generate_diagonal_moves(n)
    moves = []
    (1..n).each do |i|
      moves << [i, i]
      moves << [-i, -i]
      moves << [-i, i]
      moves << [i, -i]
    end
  end
end

class King < Piece
  def create_moves
    generate_horizontal_moves(1)
    generate_vertical_moves(1)
    generate_diagonal_moves(1)
  end
end

class Queen < Piece
  def create_moves
    generate_horizontal_moves(8)
    generate_vertical_moves(8)
    generate_diagonal_moves(8)
  end
end

class Bishop < Piece
    def create_moves
      generate_diagonal_moves(8)
    end
end

class Knight < Piece
    def create_moves
      [[2,1],[2,-1],[-2,1],[-2,1],[1,2],[-1,2],[1,-2],[-1,-2]]
    end
end

class Castle < Piece
    def create_moves
      generate_horizontal_moves(8)
      generate_vertical_moves(8)
    end
end

#if white can only move up, vice versa for black
#can move 2 space on first move
#can move diagonally to take another piece
class Pawn < Piece
    def create_moves
      if color == 'white'
        return [[0,-1],[0,-2],[1,-1],[-1,-1]]
      elsif color == 'black'
        return [[0,1],[0,2],[1,1],[-1,1]]
      end
    end
end
