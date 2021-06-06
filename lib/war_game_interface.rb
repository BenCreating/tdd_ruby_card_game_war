require_relative 'war_game'
class WarGameInterface
  attr_reader :game, :player_interfaces

  def initialize(player_interface_1, player_interface_2)
    @player_interfaces = [player_interface_1, player_interface_2]
    @last_round_table_cards = []
    @game = WarGame.new
    game.start(player_1: player_interface_1.game_player, player_2: player_interface_2.game_player)
  end

  def update_game
    if players_ready?
      round_result = game.play_round
      player_interfaces.each do |interface|
        interface.client.puts(round_result)
        interface.clear_ready
      end
    end
  end

  def run_game
    player_interfaces.each do |player_interface|
      player_interface.client.puts 'Game started, type anything to start'
    end
    until game.winner do
      update_game
    end
    puts "#{game.loser.name} is out of cards. #{game.winner.name} wins!"
  end

  def message_player(player_interface, message)
    player_interface.client.puts(message)
  end

  def players_ready?
    if player_interfaces.first.ready && player_interfaces.last.ready
      true
    else
      false
    end
  end

end
