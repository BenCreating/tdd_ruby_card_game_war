require_relative 'war_socket_server'

delay = 0.5

server = WarSocketServer.new
server.start
until server.create_game_if_possible do
  sleep(delay)
  server.accept_new_client
end

game_interface = server.game_interfaces.first
until game_interface.game.winner do
  sleep(delay)
  server.check_ready_players(game_interface)
  game_interface.update_game
end
puts "Winner: #{game_interface.game.winner.name}"

server.stop
