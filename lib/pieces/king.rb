require_relative 'piece.rb'

class King < Piece
  def create_moves
    moves = generate_horizontal_moves(1) + generate_vertical_moves(1) + generate_diagonal_moves(1)
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

  def can_castle?(distance, dir)
    through_positions = generate_moves(distance, 0, dir)
    if @has_moved == false && 
        through_positions.length == distance - 1 && 
        board.at(row, col + distance*dir).moved? == false && 
        through_positions.all? { |move| into_check?(row + move[0], col + move[1]) == false }
        return true
    end
    false
  end

  def can_short_castle?
    can_castle?(3, 1)
  end

  def short_castle_location
    [row, col + 2]
  end

  def can_long_castle?
    can_castle?(4,-1)
  end

  def long_castle_location
    [row, col - 2]
  end
end