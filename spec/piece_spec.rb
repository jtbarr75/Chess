require './lib/pieces/piece'
require './lib/board'

describe Piece do

  describe "#generate_horizontal_moves" do
    before(:each) do

    end
    it "generates an array of moves up to n spaces to the left and right that stay on the board" do
      board = object_double(Board.new, :at => nil) #every spot on board is empty
      piece = Queen.new('white', [4,0], board) 
      allow(piece).to receive(:into_check?).and_return(false)
      expect(piece.generate_horizontal_moves(8)).to eq([[0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6], [0, 7]])
    end

    it "does not return spaces if blocked by a piece of the same color" do
      board = object_double(Board.new, :at => Pawn.new('white', [3,0], nil)) #each spot on the board is always going to say its occupied by a white pawn
      piece = Queen.new('white', [4,0], board)
      allow(piece).to receive(:into_check?).and_return(false)
      expect(piece.generate_horizontal_moves(8)).to eq([])
    end

    it "returns a space if occupied by a piece of opposite color, but not spaces past that space" do
      board = object_double(Board.new, :at => Pawn.new('black', [3,0], nil)) #each spot on the board is always going to say its occupied by a black pawn
      piece = Queen.new('white', [4,0], board) 
      allow(piece).to receive(:into_check?).and_return(false)
      expect(piece.generate_horizontal_moves(8)).to eq([[0, 1]])
    end
  end

  describe "#generate_vertical_moves" do
    it "generates an array of moves up to n spaces up and down that stay on the board" do
      board = object_double(Board.new, :at => nil) #every spot on board is empty
      piece = Queen.new('white', [4,0], board) 
      allow(piece).to receive(:into_check?).and_return(false)
      expect(piece.generate_vertical_moves(8)).to eq([[1, 0], [2, 0], [3, 0], [-1, 0], [-2, 0], [-3, 0], [-4, 0]])
    end

    it "does not return spaces if blocked by a piece of the same color" do
      board = object_double(Board.new, :at => Pawn.new('white', [0,3], nil)) #each spot on the board is always going to say its occupied by a white pawn
      piece = Queen.new('white', [0,4], board) 
      allow(piece).to receive(:into_check?).and_return(false)
      expect(piece.generate_vertical_moves(8)).to eq([])
    end

    it "returns a space if occupied by a piece of opposite color, but not spaces past that space" do
      board = object_double(Board.new, :at => Pawn.new('black', [0,3], nil)) #each spot on the board is always going to say its occupied by a black pawn
      piece = Queen.new('white', [4,0], board) 
      allow(piece).to receive(:into_check?).and_return(false)
      expect(piece.generate_vertical_moves(8)).to eq([[1, 0], [-1, 0]])
    end
  end

  describe "#generate_diagonal_moves" do
    it "generates an array of moves up to n spaces diagonally that stay on the board" do
      board = object_double(Board.new, :at => nil) #every spot on board is empty
      piece = Queen.new('white', [4,4], board) 
      allow(piece).to receive(:into_check?).and_return(false)
      expected = [[1,1],[2,2],[3,3],[-1,1],[-2,2],[-3,3],[1,-1],[2,-2],[3,-3],[-1,-1],[-2,-2],[-3,-3],[-4,-4]].sort
      expect(piece.generate_diagonal_moves(8).sort).to eq(expected)
    end

    it "does not return spaces if blocked by a piece of the same color" do
      board = object_double(Board.new, :at => Pawn.new('white', [3,3], nil)) #each spot on the board is always going to say its occupied by a white pawn
      piece = Queen.new('white', [4,4], board) 
      allow(piece).to receive(:into_check?).and_return(false)
      expect(piece.generate_diagonal_moves(8)).to eq([])
    end

    it "returns a space if occupied by a piece of opposite color, but not spaces past that space" do
      board = object_double(Board.new, :at => Pawn.new('black', [3,3], nil)) #each spot on the board is always going to say its occupied by a black pawn
      piece = Queen.new('white', [4,4], board) 
      allow(piece).to receive(:into_check?).and_return(false)
      expect(piece.generate_diagonal_moves(8)).to eq([[1,1], [1,-1],[-1,-1],[-1,1]])
    end
  end

  describe "#into_check" do
    it "returns true if the move would put that colors king in check" do
      
    end
  end
end