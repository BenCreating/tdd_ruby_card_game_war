class WarPlayer
  def initialize(name = 'Anonymous', cards = CardDeck.new([]))
    @name = name
    @cards = cards
  end

  def name
    @name
  end

  def card_count
    @cards.cards_left
  end

  def play_card
    @cards.deal
  end
end
