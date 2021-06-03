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

  it "is not listening on a port before it is started"  do
    expect {MockWarSocketClient.new(@server.port_number)}.to raise_error(Errno::ECONNREFUSED)
  end

  it "accepts new clients and starts a game if possible" do
    @server.start
    client1 = create_and_accept_client("Player 1")
    @server.create_game_if_possible
    expect(@server.games.count).to be 0
    client2 = create_and_accept_client("Player 2")
    @server.create_game_if_possible
    expect(@server.games.count).to be 1
  end

  it 'reports that the game has started' do
    clients = setup_server_and_players()
    client1 = clients.first
    client2 = clients.last
    client1.capture_output
    client2.capture_output
    expect(client1.output).to eq 'Game started, type anything to start'
    expect(client2.output).to eq 'Game started, type anything to start'
  end

  it 'report when waiting for player 2 to play a card' do
    clients = setup_server_and_players()
    client1 = clients.first
    client1.capture_output # clear out the game started message
    client1.provide_input('play')
    @server.report_game_status(@server.games.first)
    client1.capture_output
    expect(client1.output).to eq 'Waiting for Player 2'
  end

  it 'report when waiting for player 1 to play a card' do
    clients = setup_server_and_players()
    client2 = clients.last
    client2.capture_output # clear out the game started message
    client2.provide_input('play')
    @server.report_game_status(@server.games.first)
    client2.capture_output
    expect(client2.output).to eq 'Waiting for Player 1'
  end

  it 'plays a round' do
    clients = setup_server_and_players()
    client1 = clients.first
    client2 = clients.last
    client1.capture_output # clear out the game started message
    client2.capture_output # clear out the game started message
    client1.provide_input('play')
    client2.provide_input('play')
    @server.update_game(@server.games.first)
    @server.report_game_status(@server.games.first)
    client1.capture_output
    client2.capture_output
    expect(client1.output).not_to eq nil
    expect(client2.output).not_to eq nil
  end

  it 'play cards if both players are ready' do
    clients = setup_server_and_players()
    client1 = clients.first
    client2 = clients.last
    client1.capture_output # clear out the game started message
    client2.capture_output # clear out the game started message
    client1.provide_input('play')
    client2.provide_input('play')
    @server.update_game(@server.games.first)
    client1.capture_output
    client2.capture_output
    waiting_message = 'Waiting for Player'
    expect(client1.output.include?(waiting_message)).to eq false
    expect(client2.output.include?(waiting_message)).to eq false
  end

  # Add more tests to make sure the game is being played
  # For example:
  #   make sure the mock client gets appropriate output
  #   make sure the next round isn't played until both clients say they are ready to play
  #   ...
end
