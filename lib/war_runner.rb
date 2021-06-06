require_relative 'war_game'

game = WarGame.new
game.start
until game.winner do
  puts game.play_round
end
puts "#{game.loser.name} is out of cards. #{game.winner.name} wins!"
