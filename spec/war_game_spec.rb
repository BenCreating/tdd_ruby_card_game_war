require_relative '../lib/war_game'
require_relative '../lib/shuffling_deck'

describe 'WarGame' do
  let(:game) { WarGame.new }

  context 'start' do
    it 'creates a deck of cards and deals them to the players' do
      game.start
      expect(game.deck_card_count).to be > 0
    end

    it 'creates 2 default players' do
      game.start
      expect(game.player_count).to eq 2
    end
  end

  it 'returns an array of the players' do
    game.start
    expect(game.players.count).to eq 2
  end
end
