class CardDeck
  RANKS = %w(A 2 3 4 5 6 7 8 9 10 J Q K)

  def initialize
    @cards = []
    card_suit_count = 4
    RANKS.each do |rank|
      card_suit_count.times { @cards << PlayingCard.new(rank) }
    end
  end

  def cardsLeft
    @cards.count
  end

  def deal
    @cards.pop
  end

  def shuffle
    @cards.shuffle!
  end
end
