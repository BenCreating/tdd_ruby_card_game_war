require 'socket'
require_relative '../lib/war_socket_server'

class MockWarSocketClient
  attr_reader :socket
  attr_reader :output

  def initialize(port)
    @socket = TCPSocket.new('localhost', port)
  end

  def provide_input(text)
    @socket.puts(text)
  end

  def capture_output(delay=0.1)
    sleep(delay)
    @output = @socket.read_nonblock(1000).chomp # not gets which blocks
  rescue IO::WaitReadable
    @output = ""
  end

  def close
    @socket.close if @socket
  end
end

describe WarSocketServer do
  before(:each) do
    @clients = []
    @server = WarSocketServer.new
  end

  after(:each) do
    @server.stop
    @clients.each do |client|
      client.close
    end
  end

  def setup_server_and_players
    @server.start
    client1 = create_and_accept_client("Player 1")
    client2 = create_and_accept_client("Player 2")
    @server.create_game_if_possible
    [client1, client2]
  end

  def create_and_accept_client(name = 'Random')
    client = MockWarSocketClient.new(@server.port_number)
    @clients.push(client)
    @server.accept_new_client(name)
    client
  end

  def capture_output(clients)
    clients.each do |client|
      client.capture_output
    end
  end

  def provide_input(clients)
    clients.each do |client|
      client.provide_input('play')
    end
  end

  it "is not listening on a port before it is started"  do
    expect {MockWarSocketClient.new(@server.port_number)}.to raise_error(Errno::ECONNREFUSED)
  end

  it "accepts new clients and starts a game if possible" do
    @server.start
    client1 = create_and_accept_client("Player 1")
    @server.create_game_if_possible
    expect(@server.game_interfaces.count).to be 0
    client2 = create_and_accept_client("Player 2")
    @server.create_game_if_possible
    expect(@server.game_interfaces.count).to be 1
  end
end
