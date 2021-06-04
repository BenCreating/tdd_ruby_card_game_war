require_relative 'war_player'

class PlayerInterface
  attr_reader :client, :game_player, :ready

  def initialize(client, player_name = 'Anonymous')
    @client = client
    @game_player = WarPlayer.new(name: player_name)
    @ready = false
  end

  def set_ready
    @ready = true
  end

  def clear_ready
    @ready = false
  end
end
