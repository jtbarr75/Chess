require_relative 'piece.rb'

class Knight < Piece
  def create_moves
    moves = []
    [[2,1],[2,-1],[-2,1],[-2,1],[1,2],[-1,2],[1,-2],[-1,-2]].each do |move|
      next unless (row + move[0]).between?(0,7) && (col + move[1]).between?(0,7)
      target = board.at(row + move[0], col + move[1])
      if target.is_a? Piece
        moves << move unless target.color == self.color
      else
        moves << move
      end
    end
    moves
  end
end