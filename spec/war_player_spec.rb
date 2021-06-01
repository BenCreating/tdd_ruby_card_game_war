require_relative '../lib/war_player'

describe 'WarPlayer' do
  it 'creates a player with the specified name' do
    player = WarPlayer.new('Alice')
    player2 = WarPlayer.new('Bob')
    expect(player.name).to eq 'Alice'
    expect(player2.name).to eq 'Bob'
  end
end
