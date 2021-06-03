require_relative 'war_game'
require_relative 'war_socket_server'

delay = 0.5

server = WarSocketServer.new
until server.create_game_if_possible do
  sleep(delay)
  server.accept_new_client
end

game = server.game.first
game.start
until game.winner do
  puts game.play_round
end
puts "Winner: #{game.winner.name}"
