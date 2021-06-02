require_relative 'war_player'

class WarGame

  def start
    @deck = ShufflingDeck.new
    @players = [WarPlayer.new('Alice'), WarPlayer.new('Bob')]
  end

  def deck_card_count
    @deck.cards_left
  end

  def player_count
    @players.count
  end
end
