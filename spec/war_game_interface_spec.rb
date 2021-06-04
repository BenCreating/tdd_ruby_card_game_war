require_relative '../lib/war_game_interface'

describe 'WarGameInterface' do
  let(:client1) { 'client1' }
  let(:client2) { 'client2' }

  it 'creates a new WarGame' do
    game_interface = WarGameInterface.new(client1, client2)
    game_interface.game.start
    expect(game_interface.game.players.count).to eq 2
  end
end
