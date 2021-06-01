class WarGame

  def start
    @deck = CardDeck.new
    @players = [WarPlayer.new, WarPlayer.new]
  end

  def deck
    @deck
  end

  def player_count
    @players.count
  end
end
