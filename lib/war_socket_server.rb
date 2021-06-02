require 'socket'
require_relative 'war_game'

class WarSocketServer
  def initialize
    @clients = {}
    @games = []
  end

  def port_number
    3336
  end

  def games
    @games
  end

  def start
    @server = TCPServer.new(port_number)
  end

  def accept_new_client(player_name = "Random Player")
    client = @server.accept_nonblock
    @clients[client] = player_name
  rescue IO::WaitReadable, Errno::EINTR
    puts "No client to accept"
  end

  def create_game_if_possible
    if @clients.count == 2
      @games << WarGame.new
      @clients.slice(2).each do |client|
        client.puts 'Game started'
      end
    end
  end

  def stop
    @server.close if @server
  end
end
