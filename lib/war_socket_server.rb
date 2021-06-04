require 'socket'
require_relative 'war_game'
require_relative 'player_interface'
require_relative 'card_deck'
require_relative 'shuffling_deck'
require_relative 'war_game_interface'

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
    game.player_interfaces.each do |player_interface|
      if capture_output(player_interface.client)
        player_interface.set_ready
      end
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
      create_game(@clients[-1], @clients[-2])
    end
  end

  def create_game(client1, client2)
    game = WarGame.new
    @games << WarGameInterface.new(client1, client2)
    game.start(player_1: client1.game_player, player_2: client2.game_player)
  end

  def stop
    @server.close if @server
  end
end
