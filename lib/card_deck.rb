require_relative 'playing_card'

class CardDeck
  attr_reader :cards

  RANKS = %w(A 2 3 4 5 6 7 8 9 10 J Q K)
  # RANKS = %w(1 2 4 4)

  def initialize(cards = default_cards())
    @cards = cards
  end

  def cards_left
    cards.count
  end

  def deal
    cards.pop
  end

  def add_card(card)
    cards.unshift(card)
  end

  private

    def default_cards
      cards = []
      card_suit_count = 4
      RANKS.each do |rank|
        card_suit_count.times { cards << PlayingCard.new(rank) }
      end
      cards
    end
end
