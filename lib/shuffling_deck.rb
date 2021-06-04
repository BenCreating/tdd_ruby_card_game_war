require_relative 'card_deck'

class ShufflingDeck < CardDeck
  def shuffle
    cards.shuffle!
  end
end
