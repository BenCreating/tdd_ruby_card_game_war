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
    round_result = WarRoundResult.new(best_card, player_1_card, player_2_card, players, table_cards_count)
    expect(round_result.winner).to eq player_1
  end

  it 'sets player 2 as the winner of the round' do
    player_1_card = loser_card
    player_2_card = best_card
    round_result = WarRoundResult.new(best_card, player_1_card, player_2_card, players, table_cards_count)
    expect(round_result.winner).to eq player_2
  end

  it 'sets the winner to nil in case of a tie' do
    player_1_card = best_card
    player_2_card = best_card
    # best_card would equal nil in this case
    round_result = WarRoundResult.new(nil, player_1_card, player_2_card, players, table_cards_count)
    expect(round_result.winner).to eq nil
  end

  it 'sets the description, player 1 wins' do
    player_1_card = best_card
    player_2_card = loser_card
    round_result = WarRoundResult.new(best_card, player_1_card, player_2_card, players, table_cards_count)
    expect(round_result.description).to eq "Player #{player_1.name} beat #{loser_card.rank} with #{best_card.rank}"
  end

  it 'sets the description, player 2 wins' do
    player_1_card = loser_card
    player_2_card = best_card
    round_result = WarRoundResult.new(best_card, player_1_card, player_2_card, players, table_cards_count)
    expect(round_result.description).to eq "Player #{player_2.name} beat #{loser_card.rank} with #{best_card.rank}"
  end

  it 'sets the description, a tied round' do
    player_1_card = best_card
    player_2_card = best_card
    # best_card would equal nil in this case
    round_result = WarRoundResult.new(nil, player_1_card, player_2_card, players, table_cards_count)
    expect(round_result.description).to eq "Both play #{best_card.rank}! There are 2 cards on the table."
  end

  it 'returns the losing card, when the losing card is the player 1 card' do
    round_result = WarRoundResult.new(best_card, best_card, loser_card, players, table_cards_count)
    expect(round_result.get_loser_card(best_card, loser_card, best_card)).to eq loser_card
  end
end
