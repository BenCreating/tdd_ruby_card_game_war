class WarPlayer
  def initialize(name = 'Anonymous', cards = [])
    @name = name
    @cards = cards
  end

  def name
    @name
  end

  def card_count
    @cards.count
  end
end
