require_relative '../lib/war_socket_client'

class MockWarSocketServer
  def port_number
    3336
  end

  def accept_new_client
    @server.accept_nonblock
  rescue IO::WaitReadable, Errno::EINTR
    nil
  end

  def start
    @server = TCPServer.new(port_number)
  end

  def stop
    @server.close if @server
  end
end

# class MockWarSocketClient
#   attr_reader :socket
#   attr_reader :output
#
#   def initialize(port)
#     @socket = TCPSocket.new('localhost', port)
#   end
#
#   def provide_input(text)
#     @socket.puts(text)
#   end
#
#   def capture_output(delay=0.1)
#     sleep(delay)
#     @output = @socket.read_nonblock(1000).chomp # not gets which blocks
#   rescue IO::WaitReadable
#     @output = ""
#   end
#
#   def close
#     @socket.close if @socket
#   end
# end

describe 'WarSocketClient' do
  before(:each) do
    @server = MockWarSocketServer.new
    @server.start
  end

  after(:each) do
    @server.stop
  end

  it 'creates a client and opens a socket on the right port' do
    client = WarSocketClient.new(@server.port_number)
    @server.accept_new_client
    expect(client.socket).not_to eq nil
    client.close
  end
end
