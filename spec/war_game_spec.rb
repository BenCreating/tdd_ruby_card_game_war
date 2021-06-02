require_relative '../lib/war_game'
require_relative '../lib/shuffling_deck'

describe 'WarGame' do
  let(:game) { WarGame.new }

  context 'start' do
    it 'returns an array of the players' do
      game.start
      expect(game.players.count).to eq 2
    end

    it 'deals cards to the players' do
      game.start
      player_card_count = game.players.first.card_count
      expect(player_card_count).to eq 26
    end
  end
end
