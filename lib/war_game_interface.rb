require_relative 'war_game'
class WarGameInterface
  attr_reader :game

  def initialize(client1, client2)
    @game = WarGame.new
  end
end
