require 'socket'
require_relative 'war_game'

class WarSocketServer
  def initialize
    @clients = []
    @games = []
    @output = ''
  end

  def port_number
    3336
  end

  def check_ready_players
    @clients.each do |client_hash|
      client = client_hash[:client]
      capture_output(client)
      if @output
        client_hash[:ready] = true
      end
    end
  end

  def report_game_state
    player_1 = @clients[0]
    player_2 = @clients[1]
    if player_1[:ready] && !player_2[:ready]
      player_1[:client].puts "Waiting for #{player_2[:name]}"
    elsif !player_1[:ready] && player_2[:ready]
      player_2[:client].puts "Waiting for #{player_1[:name]}"
    end
  end

  def capture_output(client, delay=0.1)
    sleep(delay)
    @output = client.read_nonblock(1000).chomp # not gets which blocks
  rescue IO::WaitReadable
    @output = nil
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
        client[:client].puts 'Game started, type anything to start'
      end
    end
  end

  def stop
    @server.close if @server
  end
end
