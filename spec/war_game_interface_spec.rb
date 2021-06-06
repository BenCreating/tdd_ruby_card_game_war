require_relative '../lib/war_game_interface'
require_relative '../lib/war_player'
require_relative '../lib/card_deck'
require_relative '../lib/playing_card'

class GameInterfaceMockWarSocketClient
  attr_accessor :input

  def initialize
    @input = nil
  end

  def puts(message)
    self.input = message
  end

  def capture_output
    self.input
  end
end

class MockPlayerInterface
  attr_reader :game_player
  attr_reader :ready
  attr_reader :client

  def initialize(name = 'Anonymous', cards = CardDeck.new([]))
    @client = GameInterfaceMockWarSocketClient.new
    @game_player = WarPlayer.new(name: name, cards: cards)
    @ready = false
  end

  def set_ready
    @ready = true
  end

  def clear_ready
    @ready = false
  end
end

describe 'WarGameInterface' do
  def create_hand(card_ranks)
    cards = []
    card_ranks.each do |rank|
      cards << PlayingCard.new(rank)
    end
    CardDeck.new(cards)
  end

  let(:player_interface_1) { MockPlayerInterface.new('Winning Player', create_hand(['10'])) }
  let(:player_interface_2) { MockPlayerInterface.new('Losing Player', create_hand(['3'])) }

  it 'creates a new interface which generates a WarGame' do
    game_interface = WarGameInterface.new(player_interface_1, player_interface_2)
    game_interface.game.start
    expect(game_interface.game.players.count).to eq 2
  end

  it 'creates a new interface and stores the clients' do
    game_interface = WarGameInterface.new(player_interface_1, player_interface_2)
    expect(game_interface.player_interfaces.first).to eq player_interface_1
    expect(game_interface.player_interfaces.last).to eq player_interface_2
  end

  it 'plays a round of the game' do
    game_interface = WarGameInterface.new(player_interface_1, player_interface_2)
    player_interface_1.set_ready
    player_interface_2.set_ready
    game_interface.update_game
    expect(player_interface_1.client.capture_output).not_to eq nil
  end

  it 'does not play a round if both players are not ready' do
    game_interface = WarGameInterface.new(player_interface_1, player_interface_2)
    player_interface_1.set_ready
    game_interface.update_game
    expect(player_interface_1.client.capture_output).to eq nil
  end

  it 'allows players to be specified' do
    game_interface = WarGameInterface.new(player_interface_1, player_interface_2)
    expect(game_interface.game.players.first.name).to eq player_interface_1.game_player.name
    expect(game_interface.game.players.last.name).to eq player_interface_2.game_player.name
  end

  it 'return true when both players are ready' do
    game_interface = WarGameInterface.new(player_interface_1, player_interface_2)
    player_interface_1.set_ready
    player_interface_2.set_ready
    expect(game_interface.players_ready?).to eq true
  end

  it 'return false when only player 1 is ready' do
    game_interface = WarGameInterface.new(player_interface_1, player_interface_2)
    player_interface_1.set_ready
    expect(game_interface.players_ready?).to eq false
  end

  it 'return false when only player 2 is ready' do
    game_interface = WarGameInterface.new(player_interface_1, player_interface_2)
    player_interface_2.set_ready
    expect(game_interface.players_ready?).to eq false
  end

  it 'return false when neither player is ready' do
    game_interface = WarGameInterface.new(player_interface_1, player_interface_2)
    expect(game_interface.players_ready?).to eq false
  end
end
