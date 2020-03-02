require_relative 'board.rb'

class Game
  attr_reader :board, :locations

  WHITE_SQUARE = "\u{25A0}"
  BLACK_SQUARE = "\u{25A1}"

  def initialize
    @board = Board.new
    @white_turn = true
    @locations = map_locations
  end

  def map_locations
    locations = {}
    row = 0
    col = 0
    8.downto(1) do |num|
      col = 0
      ('a'..'h').each do |letter|
        locations["#{letter}#{num}"] = [row, col]
        col += 1
      end
      row += 1
    end
    locations
  end

  #begins the game loop
  def start
    puts "Chess"
    board.print_grid
    until over?
      starting_location = choose_piece_location
      piece = board.at(starting_location[0], starting_location[1]).current
      available_moves = piece.valid_locations.map { |value| locations.key(value) }
      puts "Available moves: #{available_moves.join(", ")}"
      board.place_piece( piece, choose_destination(piece) )
      board.print_grid
      @white_turn = !@white_turn
    end
  end

  #prompts player to choose a destination
  def choose_destination(piece)
    available_moves = piece.valid_locations
    loop do
      puts "Please choose a space on the board to move to"
      space = gets.chomp
      return locations[space] if available_moves.include?(locations[space])
    end
  end

  #prompts player to choose a piece
  def choose_piece_location
    available_pieces = board.pieces(@white_turn)
    loop do
      puts "#{@white_turn ? "White" : "Black"}'s turn."
      puts "Please choose a piece to move on the board by typing its location"
      space = gets.chomp
      return locations[space] if available_pieces.include?(locations[space]) 
    end
  end

  #returns true when a player is in checkmate
  def over?
    false
  end
end
