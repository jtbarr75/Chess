require './lib/game'

describe Game do
  describe "#map_locations" do
    it "#creates a hash mapping board locations like a1 to coordinates stored in the 2d array" do
      game = Game.new
      expect(game.map_locations['a1']).to eq([7,0])
      expect(game.map_locations['b1']).to eq([7,1])
      expect(game.map_locations['h1']).to eq([7,7])
      expect(game.map_locations['a8']).to eq([0,0])
      expect(game.map_locations['h8']).to eq([0,7])
      expect(game.map_locations['e5']).to eq([3,4])
    end
  end
end