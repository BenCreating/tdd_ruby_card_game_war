require_relative 'war_player'

class PlayerInterface
  attr_reader :client
  attr_reader :game_player

  def initialize(client, player_name = 'Anonymous')
    @client = client
    @game_player = WarPlayer.new(player_name)
  end
end
