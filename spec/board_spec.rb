require './lib/board'

describe Board do
  before(:each) { @board = Board.new }

  describe "#colorize" do 
    it "sets text backround color to white" do 
      expect { puts @board.colorize("string", 'white') }.to output("\033[107;30mstring\033[0m\n").to_stdout
    end
  end

  describe "#checkmate?" do
    it "returns false if king can take the piece threatening it to escape check" do
      piece = Pawn.new('white', [1,5], @board)
      @board.place_piece(piece, [1,5])
      allow(@board).to receive(:white_pieces).and_return([piece])
      allow(piece).to receive(:valid_locations).and_return([[0,4],[0,5]])
      expect(@board.checkmate?(false)).to eq(false)
    end

    xit "returns true if king has no available moves that wouldn't also be in check" do
      pawn1 = Pawn.new('white', [1,5], @board)
      pawn2 = Pawn.new('white', [2,4], @board)
      @board.place_piece(pawn1, [1,5])
      @board.place_piece(pawn2, [2,4])
      allow(@board).to receive(:white_pieces).and_return([pawn1, pawn2])
      allow(@board).to receive(:pieces_with_moves).and_return([@board.at(0,4)])
      allow(pawn1).to receive(:valid_locations).and_return([[0,4],[0,5]])
      allow(pawn2).to receive(:valid_locations).and_return([[1,5],[1,4]])
      expect(@board.checkmate?(false)).to eq(true)
    end
  end

  describe "#king" do
    it "returns the king of specified color" do
      expect(@board.king('black')).to eq(@board.at(0,4))
    end
  end
end