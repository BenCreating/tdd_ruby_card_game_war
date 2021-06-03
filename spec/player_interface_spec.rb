require_relative '../lib/player_interface'
require_relative '../lib/war_player'
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

describe PlayerInterface do
  let(:player_name) { 'Player 1' }
  before(:each) do
    @server = WarSocketServer.new
    @server.start
    @client = MockWarSocketClient.new(@server.port_number)
  end

  after(:each) do
    @server.stop
    @client.close
  end

  it 'creates a player interface with the specified attributes' do
    player = PlayerInterface.new(@client, player_name)
    expect(player.client).to eq @client
    expect(player.game_player.name).to eq player_name
  end

  it 'sets the ready flag' do
    player = PlayerInterface.new(@client, player_name)
    player.set_ready
    expect(player.ready).to eq true
  end

  it 'clears the ready flag' do
    player = PlayerInterface.new(@client, player_name)
    player.set_ready
    player.clear_ready
    expect(player.ready).to eq false
  end

  it 'sends a message to the client' do
    message = 'Hello'
    player = PlayerInterface.new(@client, player_name)
    player.tell(message)
    expect(@client.capture_output).to eq message
  end
end
