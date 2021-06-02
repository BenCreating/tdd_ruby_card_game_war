require_relative 'war_player'
require_relative 'card_deck'
require_relative 'shuffling_deck'

class WarGame

  def start(deck = ShufflingDeck.new, hand1 = CardDeck.new([]), hand2 = CardDeck.new([]))
    @deck = deck
    @players = [WarPlayer.new('Alice', hand1), WarPlayer.new('Bob', hand2)]

    @deck.shuffle
    (@deck.cards_left/2).times do
      card = @deck.deal
      @players.first.pick_up_card(card)
    end
    @deck.cards_left.times do
      card = @deck.deal
      @players.last.pick_up_card(card)
    end

    @table_cards = []
  end

  def deck_card_count
    @deck.cards_left
  end

  def players
    @players
  end

  def table_cards
    @table_cards
  end

  def play_round
    player_1_card = @players.first.play_card
    player_2_card = @players.last.play_card

    @table_cards << player_1_card << player_2_card
    best_card = better_card(player_1_card, player_2_card)
    if best_card == player_1_card
      award_cards_to_winner(@players.first)
    elsif best_card == player_2_card
      award_cards_to_winner(@players.last)
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

    def award_cards_to_winner(player)
      @table_cards.count.times do
        card = @table_cards.pop
        player.pick_up_card(card)
      end
    end
end
