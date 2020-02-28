require_relative 'board.rb'

class Game
  attr_reader :board

  WHITE_SQUARE = "\u{25A0}"
  BLACK_SQUARE = "\u{25A1}"

  def initialize
    @board = Board.new
    @white_turn = true
  end

  #begins the game loop
  def start
    puts "Chess"
    board.print_grid
    until over?
      piece = choose_piece
      board.place_piece( piece, choose_space(piece) )
      board.print_grid
      @white_turn = !@white_turn
    end
  end

  #prompts player to choose a destination
  def choose_space(piece)
    available_moves = piece.available_moves
    loop do
      puts "Please choose a space on the board to move to"
      space = gets.chomp.to_i
      return space if available_moves.include? space 
    end
  end

  #prompts player to choose a piece
  def choose_piece
    available_pieces = board.pieces(@white_turn)
    loop do
      puts "#{@white_turn ? "White" : "Black"}'s turn."
      puts "Please choose a piece to move on the board by typing its location"
      piece = gets.chomp.to_i
      return piece if available_pieces.include? space 
    end
  end

  #returns true when a player is in checkmate
  def over?
    false
  end
end