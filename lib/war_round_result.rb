class WarRoundResult
  attr_reader :winner, :description

  def initialize(player_1_card, player_2_card, players, table_cards_count)
    winner_card = better_card(player_1_card, player_2_card)
    loser_card = worse_card(player_1_card, player_2_card)
    @winner = get_winner(winner_card, player_1_card, player_2_card, players)
    @description = write_description(winner_card, loser_card, table_cards_count, player_1_card.rank)
  end

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
    elsif ['2', '3', '4', '5', '6', '7', '8', '9', '10'].include?(card.rank)
      card.rank.to_i
    else
      0
    end
  end

  def get_winner(winner_card, player_1_card, player_2_card, players)
    if winner_card == player_1_card
      players.first
    elsif winner_card == player_2_card
      players.last
    else
      nil
    end
  end

  def worse_card(card1, card2)
    value1 = value_card(card1)
    value2 = value_card(card2)
    if value1 < value2
      card1
    elsif value2 < value1
      card2
    end
  end

  def write_description(winner_card, loser_card, table_cards_count, tied_card_rank)
    if winner_card == nil # the round is a tie
      "Both play #{tied_card_rank}! There are #{table_cards_count} cards on the table."
    else
      "Player #{winner.name} beat #{loser_card.rank} with #{winner_card.rank}"
    end
  end
end
