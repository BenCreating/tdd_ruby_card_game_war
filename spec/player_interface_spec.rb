require_relative '../lib/player_interface'
require_relative '../lib/war_player'

describe PlayerInterface do
  it 'creates a player interface with the specified attributes' do
    client = 'client'
    player_name = 'Player 1'
    player = PlayerInterface.new(client, player_name)
    expect(player.client).to eq client
    expect(player.game_player.name).to eq player_name
  end
end
