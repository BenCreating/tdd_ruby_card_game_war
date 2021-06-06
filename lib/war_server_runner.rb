require_relative 'war_socket_server'

delay = 0.5

threads = []

server = WarSocketServer.new
server.start
puts 'Server started'
loop do
  sleep(delay)
  server.accept_new_client
  game_interface = server.create_game_if_possible
  if game_interface
    puts 'Game created'
    threads << Thread.new(game_interface) { game_interface.run_game }
  end
end

server.stop
