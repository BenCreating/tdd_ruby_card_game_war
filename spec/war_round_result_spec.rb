require_relative '../lib/war_round_result'

class MockPlayingCard
  attr_reader :rank
  def initialize(rank)
    @rank = rank
  end
end

class MockWarPlayer
  attr_reader :name
  def initialize(name)
    @name = name
  end
end

describe 'WarRoundResult' do
  let(:player_1) { MockWarPlayer.new('Player 1') }
  let(:player_2) { MockWarPlayer.new('Player 2') }
  let(:players) { [player_1, player_2] }
  let(:best_card) { MockPlayingCard.new('10') }
  let(:loser_card) { MockPlayingCard.new('3') }
  let(:table_cards_count) { 2 }

  it 'sets player 1 as the winner of the round' do
    player_1_card = best_card
    player_2_card = loser_card
    round_result = WarRoundResult.new(player_1_card, player_2_card, players, table_cards_count)
    expect(round_result.winner).to eq player_1
  end

  it 'sets player 2 as the winner of the round' do
    player_1_card = loser_card
    player_2_card = best_card
    round_result = WarRoundResult.new(player_1_card, player_2_card, players, table_cards_count)
    expect(round_result.winner).to eq player_2
  end

  it 'sets the winner to nil in case of a tie' do
    player_1_card = best_card
    player_2_card = best_card
    round_result = WarRoundResult.new(player_1_card, player_2_card, players, table_cards_count)
    expect(round_result.winner).to eq nil
  end

  it 'sets the description, player 1 wins' do
    player_1_card = best_card
    player_2_card = loser_card
    round_result = WarRoundResult.new(player_1_card, player_2_card, players, table_cards_count)
    expect(round_result.description).to eq "Player #{player_1.name} beat #{loser_card.rank} with #{best_card.rank}"
  end

  it 'sets the description, player 2 wins' do
    player_1_card = loser_card
    player_2_card = best_card
    round_result = WarRoundResult.new(player_1_card, player_2_card, players, table_cards_count)
    expect(round_result.description).to eq "Player #{player_2.name} beat #{loser_card.rank} with #{best_card.rank}"
  end

  it 'sets the description, a tied round' do
    player_1_card = best_card
    player_2_card = best_card
    round_result = WarRoundResult.new(player_1_card, player_2_card, players, table_cards_count)
    expect(round_result.description).to eq "Both play #{best_card.rank}! There are 2 cards on the table."
  end

  it 'returns the losing card, when the losing card is the player 1 card' do
    round_result = WarRoundResult.new(loser_card, best_card, players, table_cards_count)
    expect(round_result.worse_card(loser_card, best_card)).to eq loser_card
  end

  it 'returns the losing card, when the losing card is the player 2 card' do
    round_result = WarRoundResult.new(best_card, loser_card, players, table_cards_count)
    expect(round_result.worse_card(best_card, loser_card)).to eq loser_card
  end

  it 'returns nil for the losing card, when there is a tie' do
    round_result = WarRoundResult.new(best_card, best_card, players, table_cards_count)
    expect(round_result.worse_card(best_card, best_card)).to eq nil
  end

  it 'returns the winning card, when the winning card is the player 1 card' do
    round_result = WarRoundResult.new(best_card, loser_card, players, table_cards_count)
    expect(round_result.better_card(best_card, loser_card)).to eq best_card
  end

  it 'returns the winning card, when the winning card is the player 2 card' do
    round_result = WarRoundResult.new(loser_card, best_card, players, table_cards_count)
    expect(round_result.better_card(best_card, loser_card)).to eq best_card
  end

  it 'returns nil for the winning card, when there is a tie' do
    round_result = WarRoundResult.new(best_card, best_card, players, table_cards_count)
    expect(round_result.better_card(best_card, best_card)).to eq nil
  end

  it 'returns the correct value for letter cards' do
    round_result = WarRoundResult.new(best_card, loser_card, players, table_cards_count)
    expect(round_result.value_card(MockPlayingCard.new('J'))).to eq 11
    expect(round_result.value_card(MockPlayingCard.new('Q'))).to eq 12
    expect(round_result.value_card(MockPlayingCard.new('K'))).to eq 13
    expect(round_result.value_card(MockPlayingCard.new('A'))).to eq 14
  end

  it 'returns the correct value for number cards' do
    round_result = WarRoundResult.new(best_card, loser_card, players, table_cards_count)
    (2..10).each do |number|
      expect(round_result.value_card(MockPlayingCard.new(number.to_s))).to eq number
    end
  end
end
