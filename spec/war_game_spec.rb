require_relative '../lib/war_game'
require_relative '../lib/shuffling_deck'

describe 'WarGame' do
  let(:game) { WarGame.new }

  context 'start' do
    it 'creates a default deck of cards' do
      game.start
      expect(game.deck_card_count).to be > 0
    end

    it 'creates 2 default players' do
      game.start
      expect(game.player_count).to eq 2
    end
  end
end
