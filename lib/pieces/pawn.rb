require_relative 'piece.rb'


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
        moves << [-2, 0] unless board.at(row - 2, col).is_a?(Piece) || board.at(row - 1, col).is_a?(Piece)
      end
      if (row - 1).between?(0, 7)
        moves << [-1, 0] unless board.at(row - 1, col).is_a? Piece
      end
      [[-1,-1],[-1,1]].each do |move|
        next unless (row + move[0]).between?(0, 7) && (col + move[1]).between?(0,7)
        target = board.at(row + move[0], col + move[1])
        if target.is_a? Piece
          moves << move unless target.color == self.color
        end
      end
    elsif @color == 'black'
      if row == 1
        moves << [2, 0] unless board.at(row + 2, col).is_a? Piece || board.at(row + 1, col).is_a?(Piece)
      end
      if (row + 1).between?(0, 7)
        moves << [1, 0] unless board.at(row + 1, col).is_a? Piece
      end
      [[1, 1],[1, -1]].each do |move|
        next unless (row + move[0]).between?(0, 7) && (col + move[1]).between?(0,7)
        target = board.at(row + move[0], col + move[1])
        if target.is_a? Piece
          moves << move unless target.color == self.color
        end
      end
    end
    moves
  end
end