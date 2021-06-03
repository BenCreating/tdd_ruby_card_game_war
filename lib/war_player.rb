class WarPlayer
  attr_reader :name

  def initialize(name: 'Anonymous', cards: CardDeck.new([]))
    @name = name
    @cards = cards
  end

  def card_count
    @cards.cards_left
  end

  def play_card
    @cards.deal
  end

  def pick_up_card(card)
    @cards.add_card(card)
  end
end
