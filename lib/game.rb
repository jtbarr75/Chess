require_relative 'board.rb'

class Game
  attr_reader :board, :locations, :white_turn

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
  def new_game
    puts "Chess"
    puts "Type 'save' at the beginning of a turn to save the game."
    start
  end

  def start
    board.print_grid
    until over?
      starting_location = choose_piece_location
      piece = board.at(starting_location[0], starting_location[1])
      destination = choose_destination(piece)
      piece.update_just_moved(destination) if piece.is_a?(Pawn)
      if destination == '0-0'
        board.short_castle(piece)
      elsif destination == '0-0-0'
        board.long_castle(piece)
      else
        board.place_piece( piece, destination)
      end
      board.print_grid
      @white_turn = !@white_turn
      board.reset_pawns(@white_turn)
    end
  end

  def new_or_load_game
    puts "Would you like to start a (n)ew game or (l)oad an existing one?"
    input = gets.chomp
    until input =~ /[nl]/
      input = gets.chomp
      puts "Please enter n for a new game or l to load a save"
    end
    input == "n" ? new_game : load_game
  end

  #prompts player to choose a destination
  def choose_destination(piece)
    available_moves = piece.valid_locations.map { |value| locations.key(value) }
    puts "Available moves: #{available_moves.join(", ")}" 
    king = (@white_turn ? board.king('white') : board.king('black'))
    can_short_castle = king.can_short_castle?
    can_long_castle = king.can_long_castle?
    if can_short_castle && can_long_castle
      puts "#0-0 to castle kingside, 0-0-0 to castle queenside"
    elsif can_short_castle
      puts "0-0 to castle kingside"
    elsif can_long_castle
      puts "0-0-0 to castle queenside"
    end
    loop do
      puts "Please choose a space on the board to move to"
      space = gets.chomp
      return locations[space] if available_moves.include?(space)
      return space if (space == '0-0' && can_short_castle) || (space == '0-0-0' && can_long_castle)
    end
  end

  #prompts player to choose a piece
  def choose_piece_location
    available_pieces = board.pieces_with_moves(@white_turn).map { |location| locations.key(location) }
    puts "#{@white_turn ? "White" : "Black"}'s turn.\n\n"
    puts "Pieces with moves: #{available_pieces.join(", ")}"
    loop do
      puts "Please choose a piece to move from the list"
      space = gets.chomp
      save if space == 'save'
      return locations[space] if available_pieces.include?(space) 
    end
  end

  #returns true when a player is in checkmate
  def over?
    king = @white_turn ? board.king('white') : board.king('black')
    if king.in_check?
      if board.checkmate?(@white_turn)
        puts "Checkmate"
        return true
      else
        puts "Check"
      end
    end
    false
  end

  
  def save
    Dir.mkdir('saves') unless Dir.exist? 'saves'
    File.open("saves/saved_game#{Dir.entries('saves').length-1} #{current_datetime}", 'w+') do |f|
      Marshal.dump(self, f)
    end
    puts 'Game saved.'
  end

  def load_game
    puts "Please choose from the following saves:"
    choices = get_save_games
    save_num = choose_save_game(choices)

    File.open(choices[save_num]) do |file|
      game = Marshal.load(file)
      @board = game.board
      @white_turn = game.white_turn
      puts "Game loaded successfully."
    end

    start
  end

  def get_save_games
    save_games = [nil]
    index = 1
    Dir.entries('saves').each do |fname|
      unless fname == ".." || fname == "."
        save_games << "saves/#{fname}"
        puts "#{index}. #{fname}"
        index += 1
      end
    end
    save_games
  end

  def choose_save_game(choices)
    save_num = gets.chomp.to_i
    until save_num.between?(1,choices.length-1)
      puts "Choose a save file from 1 - #{choices.length-1}"
      save_num = gets.chomp.to_i
    end
    save_num
  end

  def current_datetime
    Time.new.strftime("%m-%d %H:%M")
  end
end
