require_relative '../lib/card_deck'
require_relative '../lib/playing_card'

describe 'CardDeck' do
  let(:deck) { CardDeck.new }

  it 'should have 52 cards when created' do
    expect(deck.cardsLeft).to eq 52
  end

  it 'should initialize the deck with all the default cards' do
    expected_card_ranks = %w(
      2 2 2 2
      3 3 3 3
      4 4 4 4
      5 5 5 5
      6 6 6 6
      7 7 7 7
      8 8 8 8
      9 9 9 9
      10 10 10 10
      J J J J
      Q Q Q Q
      K K K K
      A A A A
    )

    deck_card_ranks = []
    52.times { deck_card_ranks << deck.deal.rank }
    expect(deck_card_ranks).to match_array expected_card_ranks
  end

  it 'should initialize with specified cards' do
    expected_ranks = %w(A 10)
    specified_cards = []
    expected_ranks.each { |rank| specified_cards << PlayingCard.new(rank)}
    specified_deck = CardDeck.new(specified_cards)

    deck_card_ranks = []
    expected_ranks.count.times { deck_card_ranks << specified_deck.deal.rank }

    expect(deck_card_ranks).to match_array expected_ranks
  end

  it 'should deal the top card' do
    unshuffled_deck_top_card = 'K'
    card = deck.deal
    expect(card.rank).to eq unshuffled_deck_top_card
    expect(deck.cardsLeft).to eq 51
  end

  it 'should shuffle the deck' do
    # There is a tiny chance that a shuffled deck will equal an unshuffled one
    deck_shuffled = deck
    deck_shuffled.shuffle

    shuffled_ranks = []
    unshuffled_ranks = []
    while deck.cardsLeft > 0
      unshuffled_ranks << deck.deal
      shuffled_ranks << deck_shuffled.deal
    end

    expect(shuffled_ranks).not_to eq unshuffled_ranks
  end
end
