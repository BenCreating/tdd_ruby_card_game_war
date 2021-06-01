require_relative '../lib/playing_card'

describe 'PlayingCard' do
  it 'should initialize with a default rank' do
    card = PlayingCard.new
    expect(card.rank).not_to be_nil
  end

  it 'should initialize with a specified rank' do
    card = PlayingCard.new('A')
    expect(card.rank).to eq 'A'
  end
end
