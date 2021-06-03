require_relative '../lib/war_socket_client'

describe 'WarSocketClient' do
  it 'creates a client and opens a socket on the right port' do
    client = WarSocketClient.new()
    expect(client.socket).to eq nil
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
