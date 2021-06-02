require_relative 'war_player'

class WarGame

  def start
    @deck = ShufflingDeck.new
    @players = [WarPlayer.new('Alice'), WarPlayer.new('Bob')]
  end

  def deck
    @deck
  end

  def player_count
    @players.count
  end
end
