require './lib/board'

describe Board do
  before(:each) { @board = Board.new }

  describe "#colorize" do 
    it "sets text backround color to white" do 
      expect { puts @board.colorize("string", 'black', 'white') }.to output("\033[107;30mstring\033[0m\n").to_stdout
    end
  end
end