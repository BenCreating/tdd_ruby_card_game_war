require_relative 'war_game'
class WarGameInterface
  attr_reader :game
  attr_reader :player_interface_1
  attr_reader :player_interface_2

  def initialize(player_interface_1, player_interface_2)
    @player_interface_1 = player_interface_1
    @player_interface_2 = player_interface_2
    @game = WarGame.new
  end
end
