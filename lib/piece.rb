class Piece
  attr_reader :name, :icon, :board
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
    @moves = create_moves
    @icon = ICONS["#{self.class.name.downcase}_#{color}".to_sym]
  end

  def to_s 
    @icon
  end

  def valid_moves
    valid_moves = []
    @moves.each do |move|
      pos = [move[0] + loc[0], move[1] + loc[1]]
      target = board.at(pos[0], pos[1]).current
      if target.instance_of?(Piece)
        valid_moves  << pos if target.color == self.color 
      end
      if pos[0].between?(0,7) && pos[1].between?(0,7)
        valid_moves << pos 
      end
    end
    valid_moves
  end

  def create_moves
    []
  end

  #add every move to the left or right up to n spaces e.g. queen can move max 7 spaces
  def generate_horizontal_moves(n, count = 0)
    return if counter > 1
    moves = []
    (1..n).each do |i|
      target = board.at(row + i, col).current
      if target.instance_of? Piece
        moves << [i, 0] unless target.color == self.color
        break
      end
    end
    moves + generate_horizontal_moves(-n, counter + 1)
  end

  #add every move up and down up to n spaces e.g. queen can move max 7 spaces
  def generate_vertical_moves(n, count = 0)
    moves = []
    (1..n).each do |i|
      target = board.at(row, col + i).current
      if target.instance_of? Piece
        moves << [0, i] unless target.color == self.color
        break
      end
    end
    moves + generate_vertical_moves(-n, count + 1)
  end

  #add every move diagonally up for max n spaces e.g. queen can move max 7 spaces
  def generate_diagonal_moves(n, count = 0)
    return if count > 1
    moves = []
    (1..n).each do |i|
      target = board.at(row + i, col + i).current
      if target.instance_of? Piece
        moves << [i, i] unless target.color == self.color
        break
      end
    end
    (1..n).each do |i|
      target = board.at(row + i, col - i).current
      if target.instance_of? Piece
        moves << [i, -i] unless target.color == self.color
        break
      end
    end
    moves + generate_diagonal_moves(-n, count + 1)
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
        target = board.at(row + move[0], col + move[1]).current
        if target.instance_of? Piece
          moves << move unless target.color == self.color
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
    @first_move = true
  end

  #update with block for board.at ?
  def create_moves
    moves = []
    if @color == 'white'
      if @first_move
        moves << [0, -2] unless board.at(row, col - 2).current.instance_of? Piece
      end
      moves << [0, -1] unless board.at(row, col - 1).current.instance_of? Piece
      [[1,-1],[-1,-1]].each do |move|
        target = board.at(row + move[0], col + move[1]).current
        if target.instance_of? Piece
          moves << move unless target.color == self.color
        end
      end
    elsif @color == 'black'
      if @first_move
        moves << [0, -2] unless board.at(row, col - 2).current.instance_of? Piece
      end
      moves << [0, -1] unless board.at(row, col - 1).current.instance_of? Piece
      [[1,-1],[-1,-1]].each do |move|
        target = board.at(row + move[0], col + move[1]).current
        if target.instance_of? Piece
          moves << move unless target.color == self.color
        end
      end
    end
    moves
  end
end

