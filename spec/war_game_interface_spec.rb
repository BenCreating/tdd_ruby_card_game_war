require_relative '../lib/war_game_interface'

describe 'WarGameInterface' do
  let(:client1) { 'client1' }
  let(:client2) { 'client2' }

  it 'creates a new interface which generates a WarGame' do
    game_interface = WarGameInterface.new(client1, client2)
    game_interface.game.start
    expect(game_interface.game.players.count).to eq 2
  end

  it 'creates a new interface and store the clients' do
    game_interface = WarGameInterface.new(client1, client2)
    expect(game_interface.client1).to eq client1
    expect(game_interface.client2).to eq client2
  end
end
