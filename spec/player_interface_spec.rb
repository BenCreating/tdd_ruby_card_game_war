require_relative '../lib/player_interface'
require_relative '../lib/war_player'

describe PlayerInterface do
  let(:client) { 'client' }
  let(:player_name) { 'Player 1' }

  it 'creates a player interface with the specified attributes' do
    player = PlayerInterface.new(client, player_name)
    expect(player.client).to eq client
    expect(player.game_player.name).to eq player_name
  end

  it 'sets the ready flag' do
    player = PlayerInterface.new(client, player_name)
    player.set_ready
    expect(player.ready).to be_true
  end
end
