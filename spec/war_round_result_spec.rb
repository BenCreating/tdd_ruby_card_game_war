require_relative '../lib/war_round_result'

class MockPlayingCard
  attr_reader :rank
  def initialize(rank)
    @rank = rank
  end
end

describe 'WarRoundResult' do
  let(:player_1) { 'Player 1' } # this would be a WarPlayer, but doesn't need to be for these tests
  let(:player_2) { 'Player 2' } # this would be a WarPlayer, but doesn't need to be for these tests
  let(:players) { [player_1, player_2] }
  let(:best_card) { MockPlayingCard.new('10') }
  let(:loser_card) { MockPlayingCard.new('3') }

  it 'sets player 1 as the winner of the round' do
    player_1_card = best_card
    player_2_card = loser_card
    round_result = WarRoundResult.new(best_card, player_1_card, player_2_card, players)
    expect(round_result.winner).to eq player_1
  end

  it 'sets player 2 as the winner of the round' do
    player_1_card = loser_card
    player_2_card = best_card
    round_result = WarRoundResult.new(best_card, player_1_card, player_2_card, players)
    expect(round_result.winner).to eq player_2
  end

  it 'sets the winner to nil in case of a tie' do
    player_1_card = best_card
    player_2_card = best_card
    round_result = WarRoundResult.new(best_card, player_1_card, player_2_card, players)
    expect(round_result.winner).to eq nil
  end
end
