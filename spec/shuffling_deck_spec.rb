require_relative '../lib/shuffling_deck'

describe 'ShufflingDeck' do
  it 'should shuffle the deck' do
    # There is a tiny chance that a shuffled deck will equal an unshuffled one
    deck = CardDeck.new
    deck_shuffled = deck
    deck_shuffled.shuffle

    shuffled_ranks = []
    unshuffled_ranks = []
    while deck.cards_left > 0
      unshuffled_ranks << deck.deal
      shuffled_ranks << deck_shuffled.deal
    end

    expect(shuffled_ranks).not_to eq unshuffled_ranks
  end
end
