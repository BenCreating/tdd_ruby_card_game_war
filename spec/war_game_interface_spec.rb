require_relative '../lib/war_game_interface'

describe 'WarGameInterface' do
  let(:player_interface_1) { 'interface 1' }
  let(:player_interface_2) { 'interface 2' }

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
end
