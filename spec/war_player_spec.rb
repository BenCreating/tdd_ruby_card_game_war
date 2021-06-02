require_relative '../lib/war_player'
require_relative '../lib/playing_card'

describe 'WarPlayer' do
  it 'creates a player without specifying attributes' do
    player = WarPlayer.new
    expect(player.name).not_to be_nil
    expect(player.card_count).to eq 0
  end

  it 'creates a player with specified attributes' do
    cards = [PlayingCard.new]
    deck = CardDeck.new(cards)
    player = WarPlayer.new('Alice', deck)
    expect(player.name).to eq 'Alice'
    expect(player.card_count).to eq cards.count
    cards2 = [PlayingCard.new, PlayingCard.new]
    deck2 = CardDeck.new(cards2)
    player2 = WarPlayer.new('Bob', deck2)
    expect(player2.name).to eq 'Bob'
    expect(player2.card_count).to eq cards2.count
  end
end
