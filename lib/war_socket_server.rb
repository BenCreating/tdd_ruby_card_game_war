require 'socket'
require_relative 'war_game'
require_relative 'player_interface'
require_relative 'card_deck'
require_relative 'shuffling_deck'

class WarSocketServer
  def initialize
    @clients = []
    @games = []
  end

  def port_number
    3336
  end

  def accept_new_client(player_name = "Random Player")
    client = @server.accept_nonblock
    @clients << PlayerInterface.new(client, player_name)
  rescue IO::WaitReadable, Errno::EINTR
    puts "No client to accept"
  end

  def check_ready_players
    @clients.each do |player|
      if capture_output(player.client)
        player.set_ready
      end
    end
  end

  def update_game(game)
    round_result = game.play_round
    game.player_1_client.puts(round_result)
    game.player_2_client.puts(round_result)
  end

  def report_game_status(game)
    player_1 = @clients[0]
    player_2 = @clients[1]
    if player_1.ready && !player_2.ready
      player_1.client.puts "Waiting for #{player_2.game_player.name}"
    elsif !player_1.ready && player_2.ready
      player_2.client.puts "Waiting for #{player_1.game_player.name}"
    end
  end

  def capture_output(client, delay=0.1)
    sleep(delay)
    client.read_nonblock(1000).chomp # not gets which blocks
  rescue IO::WaitReadable
    nil
  end

  def games
    @games
  end

  def start
    @server = TCPServer.new(port_number)
  end

  def create_game_if_possible
    if @clients.count == 2
      client1 = @clients[0]
      client2 = @clients[1]
      game = WarGame.new
      game.start(ShufflingDeck.new, CardDeck.new, CardDeck.new, client1.game_player.name, client2.game_player.name, client1.client, client2.client)
      @games << game
      @clients.first(2).each do |player|
        player.client.puts 'Game started, type anything to start'
      end
    end
  end

  def stop
    @server.close if @server
  end
end
