class WarRoundResult
  attr_reader :winner, :description

  def initialize(best_card, player_1_card, player_2_card, players, table_cards_count)
    @winner = get_winner(best_card, player_1_card, player_2_card, players)

    loser_card = get_loser_card(best_card, player_1_card, player_2_card)
    @description = write_description(best_card, loser_card, table_cards_count, player_1_card.rank)
  end

  def get_winner(best_card, player_1_card, player_2_card, players)
    if best_card == player_1_card
      players.first
    elsif best_card == player_2_card
      players.last
    else
      nil
    end
  end

  def get_loser_card(best_card, player_1_card, player_2_card)
    if best_card == nil
      nil
    elsif best_card != player_1_card
      player_1_card
    elsif best_card != player_2_card
      player_2_card
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
