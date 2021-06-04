require_relative '../lib/war_game_interface'

describe 'WarGameInterface' do
  let(:player_interface_1) { 'interface 1' }
  let(:player_interface_2) { 'interface 2' }

  it 'creates a new interface which generates a WarGame' do
    game_interface = WarGameInterface.new(player_interface_1, player_interface_2)
    game_interface.game.start
    expect(game_interface.game.players.count).to eq 2
  end

  it 'creates a new interface and store the clients' do
    game_interface = WarGameInterface.new(player_interface_1, player_interface_2)
    expect(game_interface.player_interface_1).to eq player_interface_1
    expect(game_interface.player_interface_2).to eq player_interface_2
  end
end
