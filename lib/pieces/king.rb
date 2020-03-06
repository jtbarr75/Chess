require_relative 'piece.rb'

class King < Piece
  def create_moves
    generate_horizontal_moves(1) + generate_vertical_moves(1) + generate_diagonal_moves(1)
  end

  def in_check?(r = self.row, c = self.col)
    threatened_locations = []
    enemies = (color == 'black' ? board.white_pieces : board.black_pieces)
    enemies.each do |piece|
      threatened_locations << piece.threatened_locations 
    end
    if threatened_locations.flatten(1).include?([r, c])
      return true
    end
    false
  end
end