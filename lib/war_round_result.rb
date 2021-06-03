class WarRoundResult
  attr_reader :winner

  def initialize(best_card, player_1_card, player_2_card, players)
    @winner = get_winner(best_card, player_1_card, player_2_card, players)
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
end
