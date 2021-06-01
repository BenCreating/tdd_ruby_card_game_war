require_relative '../lib/war_game'

describe 'WarGame' do
  let(:game) { WarGame.new }

  context 'start' do
    it 'creates a deck of cards' do
      game.start
      expect(game.deck).not_to be_nil
    end
  end
end
