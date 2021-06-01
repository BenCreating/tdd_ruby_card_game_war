require_relative '../lib/card_deck'

describe 'CardDeck' do
  let(:deck) { CardDeck.new }

  it 'Should have 52 cards when created' do
    expect(deck.cardsLeft).to eq 52
  end

  it 'should deal the top card' do
    card = deck.deal
    expect(card).to_not be_nil
    expect(deck.cardsLeft).to eq 51
  end
end
