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
    player = WarPlayer.new('Alice', CardDeck.new(cards))
    expect(player.name).to eq 'Alice'
    expect(player.card_count).to eq cards.count
    cards2 = [PlayingCard.new, PlayingCard.new]
    player2 = WarPlayer.new('Bob', CardDeck.new(cards2))
    expect(player2.name).to eq 'Bob'
    expect(player2.card_count).to eq cards2.count
  end

  it 'plays the top card from the hand' do
    player = WarPlayer.new('Alice', CardDeck.new([PlayingCard.new('A'), PlayingCard.new('K')]))
    played_card = player.play_card
    expect(played_card.rank).to eq 'K'
    player2 = WarPlayer.new('Bob', CardDeck.new([PlayingCard.new('2'), PlayingCard.new('3')]))
    played_card2 = player2.play_card
    expect(played_card2.rank).to eq '3'
  end
end
