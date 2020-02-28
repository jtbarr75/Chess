class Piece
  attr_reader :name, :icon
  attr_accessor :location

  ICONS = { king_white: "\u{2654}", king_black "\u{265A}",
            queen_white: "\u{2655}", queen_black: "\u{265B}",
            bishop_white: "\u{2657}", bishop_black: "\u{265D}",
            knight_white: "\u{2658}", knight_black: "\u{265E}",
            castle_white: "\u{2656}", castle_black: "\u{265C}",
            pawn_white: "\u{2659}", pawn_black: "\u{265F}" }

  def initialize(color, location)
    @location = location
    @moves = create_moves
    @icon = @icon = ICONS["#{self.class.name.downcase}_#{color}".to_sym]
  end

  #move to board and check against othe piece locations who might be blocking
  #each piece is initialized with all valid moves from their location
  def create_moves
    valid_moves = []
    @moves.each do |move|
      location = [move[0] + loc[0], move[1] + loc[1]]
      valid_moves << location if location[0].between?(0,7) && location[1].between?(0,7)
    end
    valid_moves
  end

  def create_moves
    []
  end
end

class King < Piece
  def create_moves
    [[1,1],[1,-1],[1,0][-1,1],[-1,-1],[-1,0],[0,1],[0,-1]]
  end
end

#make this dryer pls
class Queen < Piece
  def create_moves
    moves = []
    #add every move to the right until the end of board
    x = location[0]
    i = 0
    until x > 7
      moves << [i, 0]
      i += 1
      x += 1
    end
    #add every move to the left until the end of board
    x = location[0]
    i = 0
    until x < 0
      moves << [i, 0]
      i -= 1
      x -= 1
    end
    #add every move up until the end of board
    y = location[1]
    i = 0
    until y < 0
      moves << [0, i]
      i -= 1
      y -= 1
    end
    #add every move down until the end of board
    y = location[1]
    i = 0
    until y > 7
      moves << [0, i]
      i += 1
      y += 1
    end
    #add every move up-left until the end of board
    x = location[0]
    y = location[1]
    i = 0
    until x < 0 || y < 0
      moves << [i, i]
      i -= 1
      x -= 1
      y -= 1
    end
    #add every move up-right until the end of board
    x = location[0]
    y = location[1]
    i = 0
    until x > 7 || y < 0
      moves << [i, -i]
      i += 1
      x += 1
      y -= 1
    end
    #add every move down-right until the end of board
    x = location[0]
    y = location[1]
    i = 0
    until x > 7 || y > 7
      moves << [i, i]
      i += 1
      x += 1
      y += 1
    end
    #add every move down-right until the end of board
    x = location[0]
    y = location[1]
    i = 0
    until x < 0 || y > 7
      moves << [-i, i]
      i += 1
      x -= 1
      y += 1
    end
    moves
  end
end

class Bishop < Piece
    def create_moves

    end
end

class Knight < Piece
    def create_moves

    end
end

class Castle < Piece
    def create_moves

    end
end

class Pawn < Piece
    def create_moves

    end
end
