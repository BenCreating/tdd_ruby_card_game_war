class WarGame

  def start
    @deck = CardDeck.new
    @players = [WarPlayer.new('Alice'), WarPlayer.new('Bob')]
  end

  def deck
    @deck
  end

  def player_count
    @players.count
  end
end
