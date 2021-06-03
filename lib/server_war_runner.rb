require_relative 'war_socket_server'

delay = 0.5

server = WarSocketServer.new
server.start
until server.create_game_if_possible do
  sleep(delay)
  server.accept_new_client
end

game = server.games.first
game.start
until game.winner do
  sleep(delay)
  server.update_game(game)
end
puts "Winner: #{game.winner.name}"

server.stop
