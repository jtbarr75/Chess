

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
      target = board.at(row + i, col).current
      if target.is_a? Piece
        moves << [i, 0] unless target.color == self.color
        break
      else
        moves << [i,0]
      end
    end
    (1..n).each do |i| 
      break if row - i < 0
      target = board.at(row - i, col).current
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
      target = board.at(row, col + i).current
      if target.is_a? Piece
        moves << [0, i] unless target.color == self.color
        break
      else
        moves << [0,i]
      end
    end
    (1..n).each do |i|
      break if col - i < 0
      target = board.at(row, col - i).current
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
      target = board.at(row + i, col + i).current
      if target.is_a? Piece
        moves << [i, i] unless target.color == self.color
        break
      else
        moves << [i, i]
      end
    end
    (1..n).each do |i|
      break if row + i > 7 || col - i < 0
      target = board.at(row + i, col - i).current
      if target.is_a? Piece
        moves << [i, -i] unless target.color == self.color
        break
      else
        moves << [i, -i]
      end
    end
    (1..n).each do |i|
      break if row - i < 0 || col - i < 0
      target = board.at(row - i, col - i).current
      if target.is_a? Piece
        moves << [-i, -i] unless target.color == self.color
        break
      else
        moves << [-i, -i]
      end
    end
    (1..n).each do |i|
      break if row - i < 0 || col + i > 7
      target = board.at(row - i, col + i).current
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

class King < Piece
  def create_moves
    generate_horizontal_moves(1) + generate_vertical_moves(1) + generate_diagonal_moves(1)
  end
end

class Queen < Piece
  def create_moves
    generate_horizontal_moves(8) + generate_vertical_moves(8) + generate_diagonal_moves(8)
  end
end

class Bishop < Piece
    def create_moves
      generate_diagonal_moves(8)
    end
end

class Knight < Piece
    def create_moves
      moves = []
      [[2,1],[2,-1],[-2,1],[-2,1],[1,2],[-1,2],[1,-2],[-1,-2]].each do |move|
        next unless (row + move[0]).between?(0,7) && (col + move[1]).between?(0,7)
        target = board.at(row + move[0], col + move[1]).current
        if target.is_a? Piece
          moves << move unless target.color == self.color
        else
          moves << move
        end
      end
      moves
    end
end

class Castle < Piece
  def create_moves
    generate_horizontal_moves(8) + generate_vertical_moves(8)
  end
end

#if white can only move up, vice versa for black
#can move 2 space on first move
#can move diagonally to take another piece
class Pawn < Piece
  def initialize(color, pos, board)
    super(color, pos, board)
  end

  #update with block for board.at ?
  #BIG UGLY pls reformat
  def create_moves
    moves = []
    if @color == 'white'
      if row == 6
        moves << [-2, 0] unless board.at(row - 2, col).current.is_a?(Piece) || board.at(row - 1, col).current.is_a?(Piece)
      end
      if (row - 1).between?(0, 7)
        moves << [-1, 0] unless board.at(row - 1, col).current.is_a? Piece
      end
      [[-1,-1],[-1,1]].each do |move|
        next unless (row + move[0]).between?(0, 7) && (col + move[1]).between?(0,7)
        target = board.at(row + move[0], col + move[1]).current
        if target.is_a? Piece
          moves << move unless target.color == self.color
        end
      end
    elsif @color == 'black'
      if row == 1
        moves << [2, 0] unless board.at(row + 2, col).current.is_a? Piece || board.at(row + 1, col).current.is_a?(Piece)
      end
      if (row + 1).between?(0, 7)
        moves << [1, 0] unless board.at(row + 1, col).current.is_a? Piece
      end
      [[1, 1],[1, -1]].each do |move|
        next unless (row + move[0]).between?(0, 7) && (col + move[1]).between?(0,7)
        target = board.at(row + move[0], col + move[1]).current
        if target.is_a? Piece
          moves << move unless target.color == self.color
        end
      end
    end
    moves
  end
end

