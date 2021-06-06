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
        message_player(interface, round_result)
        interface.clear_ready
      end
    end
  end

  def run_game
    player_interfaces.each { |interface| message_player(interface, 'Game started, type anything to start') }
    until game.winner do
      update_game
    end
    puts "#{game.loser.name} is out of cards. #{game.winner.name} wins!"
  end

  def message_player(player_interface, message)
    player_interface.client.puts(message)
  end

  def update_ready_players
    player_interfaces.each do |interface|
      if capture_output(interface.client)
        interface .set_ready
      end
    end
  end

  def capture_output(client, delay=0.1)
    sleep(delay)
    client.read_nonblock(1000).chomp # not gets which blocks
  rescue IO::WaitReadable
  end

  def players_ready?
    update_ready_players
    if player_interfaces.first.ready && player_interfaces.last.ready
      true
    else
      false
    end
  end

end
