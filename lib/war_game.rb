require_relative 'war_player'

class WarGame

  def start(deck = ShufflingDeck.new)
    @deck = deck
    @players = [WarPlayer.new('Alice'), WarPlayer.new('Bob')]

    @deck.shuffle
    (@deck.cards_left/2).times do
      card = @deck.deal
      @players.first.pick_up_card(card)
    end
    @deck.cards_left.times do
      card = @deck.deal
      @players.last.pick_up_card(card)
    end
  end

  def deck_card_count
    @deck.cards_left
  end

  def players
    @players
  end
end
