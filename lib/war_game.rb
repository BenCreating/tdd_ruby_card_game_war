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

  def play_round
    player_1_card = @players.first.play_card
    player_2_card = @players.last.play_card

    best_card = better_card(player_1_card, player_2_card)
    if best_card == player_1_card
      @players.first.pick_up_card(player_1_card)
      @players.first.pick_up_card(player_2_card)
    elsif best_card == player_2_card
      @players.last.pick_up_card(player_1_card)
      @players.last.pick_up_card(player_2_card)
    end
  end

  private

    def better_card(card1, card2)
      value1 = value_card(card1)
      value2 = value_card(card2)
      if value1 > value2
        card1
      elsif value2 > value1
        card2
      end
    end

    def value_card(card)
      if ['A', 'J', 'Q', 'K'].include?(card.rank)
        {'J' => 11, 'Q' => 12, 'K' => 13, 'A' => 14}.fetch(card.rank)
      else
        card.rank.to_i
      end
    end
end
