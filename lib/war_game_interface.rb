require_relative 'war_game'
class WarGameInterface
  attr_reader :game
  attr_reader :player_interfaces

  def initialize(player_interface_1, player_interface_2)
    @player_interfaces = [player_interface_1, player_interface_2]
    @game = WarGame.new
    game.start(player_1: player_interface_1.game_player, player_2: player_interface_2.game_player)
  end

  def update_game
    if player_interfaces.first.ready && player_interfaces.last.ready
      round_result = game.play_round
      player_interfaces.each do |interface|
        interface.client.puts(round_result)
        interface.clear_ready
      end
    end
  end
end
