require_relative '../lib/war_player'

describe 'WarPlayer' do
  it 'creates a player without specifying attributes' do
    player = WarPlayer.new
    expect(player.name).not_to be_nil
  end

  it 'creates a player with specified attributes' do
    player = WarPlayer.new('Alice')
    player2 = WarPlayer.new('Bob')
    expect(player.name).to eq 'Alice'
    expect(player2.name).to eq 'Bob'
  end
end
