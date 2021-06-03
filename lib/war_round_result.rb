class WarRoundResult
  attr_reader :winner

  def initialize(best_card, player_1_card, player_2_card, players)
    if best_card == player_1_card
      @winner = players.first
    elsif best_card == player_2_card
      @winner = players.last
    else
      @winner = nil
    end
  end
end
