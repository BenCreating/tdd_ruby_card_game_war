class WarSocketClient
  attr_reader :socket

  def initialize(port)
    @socket = TCPSocket.new('localhost', port)
  end

  def close
    @socket.close if @socket
  end
end
