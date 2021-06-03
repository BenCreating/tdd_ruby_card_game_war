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
    puts "Client #{player_name} connected"
  rescue IO::WaitReadable, Errno::EINTR
    puts "No client to accept"
  end

  def check_ready_players(game)
    game_clients = lookup_clients(game)
    game_clients.each do |player|
      if capture_output(player.client)
        player.set_ready
      end
    end
  end

  def update_game(game)
    round_result = game.play_round
    game_clients = lookup_clients(game)
    check_ready_players(game)
    if game_clients.first.ready && game_clients.last.ready
      game_clients.each do |client_interface|
        client_interface.client.puts(round_result)
        client_interface.clear_ready
      end
    end
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
      game.start(player_1: client1.game_player, player_2: client2.game_player)
      @games << game
      @clients.first(2).each do |player|
        player.client.puts 'Game started, type anything to start'
      end
    end
  end

  def stop
    @server.close if @server
  end

  private

    def lookup_clients(game)
      game_clients = []
      players = game.players
      players.each do |player|
        game_clients << find_client_by_player(player)
      end
      game_clients
    end

    def find_client_by_player(player)
      player_client = nil
      @clients.each do |client|
        if client.game_player == player
          player_client = client
          break
        end
      end
      player_client
    end
end
