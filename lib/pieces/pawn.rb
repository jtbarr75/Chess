require_relative 'piece.rb'


#if white can only move up, vice versa for black
#can move 2 space on first move
#can move diagonally to take another piece
class Pawn < Piece
  attr_accessor :just_moved_two

  def initialize(color, pos, board)
    @just_moved_two = false
    @last_pos
    super(color, pos, board)
  end

  #called when board moves the pawn. @just_moved_two will be true only for the opponents turn immediately following this move
  def set_location(loc)
    @last_pos = [row, col]
    super(loc)
  end

  def update_just_moved(destination)
    if destination[0] == row + 2 || destination[0] == row - 2
      puts 'updated'
      @just_moved_two = true 
    end
  end

  def create_moves
    moves = []
    if @color == 'white'
      #check for first move, can move two spaces
      if @has_moved == false
        moves << [-2, 0] unless board.at(row - 2, col).is_a?(Piece) || board.at(row - 1, col).is_a?(Piece)
      end
      #check for normal move one space
      if (row - 1).between?(0, 7)
        moves << [-1, 0] unless board.at(row - 1, col).is_a? Piece
      end
      #check for taking piece
      [[-1,-1],[-1,1]].each do |move|
        next unless (row + move[0]).between?(0, 7) && (col + move[1]).between?(0,7)
        target = board.at(row + move[0], col + move[1])
        if target.is_a? Piece
          moves << move unless target.color == self.color
        end
        #check for en passant
        target = board.at(row, col + move[1])
        if target.is_a?(Pawn) && target.color != self.color && target.just_moved_two
          moves << move
        end
      end
    elsif @color == 'black'
      #check for first move, can move two spaces
      if @has_moved == false
        moves << [2, 0] unless board.at(row + 2, col).is_a? Piece || board.at(row + 1, col).is_a?(Piece)
      end
      #check for normal move one space
      if (row + 1).between?(0, 7)
        moves << [1, 0] unless board.at(row + 1, col).is_a? Piece
      end
      #check for taking piece
      [[1, 1],[1, -1]].each do |move|
        next unless (row + move[0]).between?(0, 7) && (col + move[1]).between?(0,7)
        target = board.at(row + move[0], col + move[1])
        if target.is_a? Piece
          moves << move unless target.color == self.color
        end
        #check for en passant
        target = board.at(row, col + move[1])
        if target.is_a?(Pawn) && target.color != self.color && target.just_moved_two
          moves << move
        end
      end
    end
    moves
  end
end