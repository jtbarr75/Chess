require './lib/board'

describe Board do
  before(:each) { @board = Board.new }

  W = "\u{25A0}"
  B = "\u{25A1}"

  describe "#create_grid" do
    it "creates a 8x8 grid of alternating black and white squares" do
      expect(@board.grid).to eq( [[B, W, B, W, B, W, B, W],
                                  [W, B, W, B, W, B, W, B],
                                  [B, W, B, W, B, W, B, W],
                                  [W, B, W, B, W, B, W, B],
                                  [B, W, B, W, B, W, B, W],
                                  [W, B, W, B, W, B, W, B],
                                  [B, W, B, W, B, W, B, W],
                                  [W, B, W, B, W, B, W, B]] )
    end
  end
end