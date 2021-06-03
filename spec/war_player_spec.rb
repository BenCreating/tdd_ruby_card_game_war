require_relative '../lib/war_player'
require_relative '../lib/playing_card'
require_relative '../lib/card_deck'

describe 'WarPlayer' do
  let(:winning_hand) {  }
  it 'creates a player without specifying attributes' do
    player = WarPlayer.new()
    expect(player.name).not_to be_nil
    expect(player.card_count).to eq 0
  end

  it 'creates a player with specified attributes' do
    player = WarPlayer.new(name: 'Alice', cards: CardDeck.new([PlayingCard.new]))
    expect(player.name).to eq 'Alice'
    expect(player.card_count).to eq 1
    player2 = WarPlayer.new(name: 'Bob', cards: CardDeck.new([PlayingCard.new, PlayingCard.new]))
    expect(player2.name).to eq 'Bob'
    expect(player2.card_count).to eq 2
  end

  it 'plays the top card from the hand' do
    player = WarPlayer.new(name: 'Alice', cards: CardDeck.new([PlayingCard.new('A'), PlayingCard.new('K')]))
    played_card = player.play_card
    expect(played_card.rank).to eq 'K'
    player2 = WarPlayer.new(name: 'Bob', cards: CardDeck.new([PlayingCard.new('2'), PlayingCard.new('3')]))
    played_card2 = player2.play_card
    expect(played_card2.rank).to eq '3'
  end

  it 'adds a card to the hand' do
    player = WarPlayer.new()
    player.pick_up_card(PlayingCard.new)
    expect(player.card_count).to eq 1
  end
end
