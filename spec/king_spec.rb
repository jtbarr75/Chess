require './lib/pieces/king'

describe King do
  before(:each) { @board = Board.new }

  describe "#in_check?" do
      it "returns true if black is threatened by any piece" do
        piece = Pawn.new('white', [1,5], @board)
        allow(@board).to receive(:white_pieces).and_return([piece])
        allow(piece).to receive(:valid_locations).and_return([[0,4],[0,5]])
        expect(@board.king('black').in_check?).to eq(true)
      end

      it "returns false if not threatened" do
        expect(@board.king('black').in_check?).to eq(false)
      end
    end

    
  end