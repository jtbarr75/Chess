require_relative 'piece.rb'

class Queen < Piece
  def create_moves
    generate_horizontal_moves(8) + generate_vertical_moves(8) + generate_diagonal_moves(8)
  end
end