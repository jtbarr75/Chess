require_relative 'piece.rb'

class Bishop < Piece
  def create_moves
    generate_diagonal_moves(8)
  end
end