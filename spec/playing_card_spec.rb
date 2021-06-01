require_relative '../lib/playing_card'

describe 'PlayingCard' do
  it 'should initialize with a specified rank' do
    card = PlayingCard.new('A')
    expect(card.rank).to eq 'A'
  end
end
