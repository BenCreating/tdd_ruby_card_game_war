require_relative '../lib/war_player'

describe 'WarPlayer' do
  it 'create a player with the specified name' do
    player = WarPlayer.new('Alice')
    expect(player.name).to eq 'Alice'
  end
end
