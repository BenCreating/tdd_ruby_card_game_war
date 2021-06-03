class WarRoundResult
  attr_reader :winner
  attr_reader :description

  def initialize(best_card, player_1_card, player_2_card, players, table_cards_count)
    @player_1 = players.first
    @player_2 = players.last
    @winner = get_winner(best_card, player_1_card, player_2_card, players)
    @description = write_description(best_card, player_1_card, player_2_card, table_cards_count)
  end

  def get_winner(best_card, player_1_card, player_2_card, players)
    if best_card == player_1_card
      @player_1
    elsif best_card == player_2_card
      @player_2
    else
      nil
    end
  end

  def write_description(best_card, player_1_card, player_2_card, table_cards_count)
    if best_card == player_1_card
      loser_card = player_2_card
    elsif best_card == player_2_card
      loser_card = player_1_card
    else
      loser_card = nil
    end

    if winner == @player_1
      "Player #{winner.name} beat #{loser_card.rank} with #{best_card.rank}"
    elsif winner == @player_2
      "Player #{winner.name} beat #{loser_card.rank} with #{best_card.rank}"
    else # the round is a tie
      "Both play #{best_card.rank}! There are #{table_cards_count} cards on the table."
    end
  end
end
