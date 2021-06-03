require_relative '../lib/player_interface'
require_relative '../lib/war_player'

describe PlayerInterface do
  it 'creates a player interface with the specified attributes' do
    client = 'client'
    game_player = WarPlayer.new
    player = PlayerInterface.new(client, game_player)
    expect(player.client).to eq client
    expect(player.game_player).to eq game_player
  end
end
