require_relative 'piece.rb'

class King < Piece
  def create_moves
    generate_horizontal_moves(1) + generate_vertical_moves(1) + generate_diagonal_moves(1)
  end
end