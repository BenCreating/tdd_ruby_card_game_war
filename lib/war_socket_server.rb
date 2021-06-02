require 'socket'
require_relative 'war_game'

class WarSocketServer
  def initialize
    @clients = []
    @games = []
  end

  def port_number
    3336
  end

  def capture_output(client, delay=0.1)
    sleep(delay)
    @output = @client.read_nonblock(1000).chomp # not gets which blocks
  rescue IO::WaitReadable
    @output = ""
  end

  def games
    @games
  end

  def start
    @server = TCPServer.new(port_number)
  end

  def accept_new_client(player_name = "Random Player")
    client = @server.accept_nonblock
    @clients << {client: client, name: player_name}
  rescue IO::WaitReadable, Errno::EINTR
    puts "No client to accept"
  end

  def create_game_if_possible
    if @clients.count == 2
      @games << WarGame.new
      @clients.first(2).each do |client|
        client[:client].puts 'Game started, hit enter to play a card'
      end
    end
  end

  def stop
    @server.close if @server
  end
end
