

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
    @has_moved = false
    @initial_position = pos
  end

  def to_s 
    @icon
  end

  def set_location(loc)
    @row = loc[0]
    @col = loc[1]
  end

  #has this piece moved since the beginning of the game
  def moved?
    row != @initial_position[0] || col != @initial_position[1]
  end

  #returns the valid locations the piece can move to, not placing own king in check
  def valid_locations
    @has_moved = moved? if @has_moved == false
    create_moves.select { |move| into_check?(row + move[0], col + move[1]) == false}
                .map { |move| [move[0] + row, move[1] + col] }
  end

  #all the locations a piece could take another piece, doesn't use into_check? to prevent infinite recursion
  def threatened_locations
    create_moves.map { |move| [move[0] + row, move[1] + col] }
  end

  #used to generate moves horizontally, vertically, diagonally
  #returns an array of locations moving from the current location in the horizontal/vertical direction (-1,0,1) up to edges of the board 0 or 7
  def generate_moves(n, row_dir, col_dir)
    moves = []
    (1..n).each do |i| 
      new_row = row + i*row_dir
      new_col = col + i*col_dir
      break if (new_row > 7 || new_row < 0) || (new_col > 7 || new_col < 0)
      target = board.at(new_row, new_col)
      if target.is_a? Piece
        moves << [i*row_dir, i*col_dir] unless target.color == self.color
        break
      else
        moves << [i*row_dir, i*col_dir]
      end
    end
    moves
  end

  #returns true if moving to the new location would place own king into check
  def into_check?(new_row, new_col)
    check = false
    king = board.king(color)
    piece_at_destination = board.at(new_row, new_col)

    initial_row, initial_col = self.row, self.col
    board.place_piece(self, [new_row, new_col])
    check = true if king.in_check?
    
    board.place_piece(self, [initial_row, initial_col])
    board.place_piece(piece_at_destination, [new_row, new_col], false) if piece_at_destination
    check
  end

  #add every move to the left or right up to n spaces e.g. queen can move max 7 spaces
  def generate_horizontal_moves(n)
    generate_moves(n, 0, 1) + generate_moves(n, 0, -1)
  end

  #add every move up and down up to n spaces e.g. queen can move max 7 spaces
  def generate_vertical_moves(n)
    generate_moves(n, 1, 0) + generate_moves(n, -1, 0)
  end

  #add every move diagonally up for max n spaces e.g. queen can move max 7 spaces
  def generate_diagonal_moves(n)
    generate_moves(n, 1, 1) + generate_moves(n, 1, -1) + generate_moves(n, -1, -1) + generate_moves(n, -1, 1)
  end
end