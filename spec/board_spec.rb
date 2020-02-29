require './lib/board'

describe Board do
  before(:each) { @board = Board.new }

  W = "\u{25A0}"
  B = "\u{25A1}"

  describe "#create_blank_board" do
    it "creates a 8x8 grid of alternating black and white squares" do
      allow(@board).to receive(:grid).and_return(@board.create_blank_board)
      expected = 
      <<~EXPECTED
      #{B} #{W} #{B} #{W} #{B} #{W} #{B} #{W}
      #{W} #{B} #{W} #{B} #{W} #{B} #{W} #{B}
      #{B} #{W} #{B} #{W} #{B} #{W} #{B} #{W}
      #{W} #{B} #{W} #{B} #{W} #{B} #{W} #{B}
      #{B} #{W} #{B} #{W} #{B} #{W} #{B} #{W}
      #{W} #{B} #{W} #{B} #{W} #{B} #{W} #{B}
      #{B} #{W} #{B} #{W} #{B} #{W} #{B} #{W}
      #{W} #{B} #{W} #{B} #{W} #{B} #{W} #{B}
      EXPECTED
      expect { @board.print_grid }.to output(expected).to_stdout
    end
  end
end