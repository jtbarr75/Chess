require_relative 'piece.rb'

class Board
  attr_reader :grid

  WHITE_SQUARE = "\u{25A0}"
  BLACK_SQUARE = "\u{25A1}"
  
  def initialize
    @grid = create_grid
  end

  #Create a 8x8 grid of alternating black and white squares
  def create_grid
    white, black  = Array.new(4, WHITE_SQUARE), Array.new(4, BLACK_SQUARE)
    line = black.zip(white).flatten
    grid = []
    4.times { grid << line; grid << line.reverse }
    grid
  end

  #Prints the grid
  def print_grid
    grid.each { |row| puts row.join(" ") }
  end

end