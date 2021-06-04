require 'socket'
require_relative 'war_game'
require_relative 'player_interface'
require_relative 'card_deck'
require_relative 'shuffling_deck'
require_relative 'war_game_interface'

class WarSocketServer
  attr_reader :games, :player_interface_queue

  def initialize
    @player_interface_queue = []
    @games = []
  end

  def port_number
    3336
  end

  def accept_new_client(player_name = "Random Player")
    client = @server.accept_nonblock
    player_interface_queue << PlayerInterface.new(client, player_name)
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

  def start
    @server = TCPServer.new(port_number)
  end

  def create_game_if_possible
    if player_interface_queue.count >= 2
      game = create_game(player_interface_queue.pop, player_interface_queue.pop)
      game.player_interfaces.each do |player_interface|
        player_interface.client.puts 'Game started, type anything to start'
      end
    end
  end

  def create_game(client1, client2)
    game_interface = WarGameInterface.new(client1, client2)
    @games << game_interface
    game_interface
  end

  def stop
    @server.close if @server
  end
end
