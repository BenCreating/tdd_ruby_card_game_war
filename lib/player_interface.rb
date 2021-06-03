require_relative 'war_player'

class PlayerInterface
  attr_reader :client
  attr_reader :game_player
  attr_reader :ready

  def initialize(client, player_name = 'Anonymous')
    @client = client
    @game_player = WarPlayer.new(player_name)
    @ready = false
  end

  def set_ready
    @ready = true
  end
end
