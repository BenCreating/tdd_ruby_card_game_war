require_relative '../lib/war_round_result'
require_relative '../lib/war_game'

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

  let(:tied_cards) { [MockPlayingCard.new('10'), MockPlayingCard.new('10')] }
  let(:player_1_wins_cards) { [MockPlayingCard.new('10'), MockPlayingCard.new('3')] }
  let(:player_2_wins_cards) { [MockPlayingCard.new('3'), MockPlayingCard.new('10')] }

  it 'sets player 1 as the winner of the round' do
    round_result = WarRoundResult.new(player_1_wins_cards, players)
    expect(round_result.winner).to eq player_1
  end

  it 'sets player 2 as the winner of the round' do
    round_result = WarRoundResult.new(player_2_wins_cards, players)
    expect(round_result.winner).to eq player_2
  end

  it 'sets the winner to nil in case of a tie' do
    round_result = WarRoundResult.new(tied_cards, players)
    expect(round_result.winner).to eq nil
  end

  it 'sets the description for a player 1 win' do
    round_result = WarRoundResult.new(player_1_wins_cards, players)
    expect(round_result.description).to eq "Player #{player_1.name} beat #{player_1_wins_cards.last.rank} with #{player_1_wins_cards.first.rank}"
  end

  it 'sets the description, for a  player 2 win' do
    round_result = WarRoundResult.new(player_2_wins_cards, players)
    expect(round_result.description).to eq "Player #{player_2.name} beat #{player_2_wins_cards.first.rank} with #{player_2_wins_cards.last.rank}"
  end

  it 'sets the description of a tied round' do
    table_cards = tied_cards * (WarGame::EXTRA_TIE_CARDS + 1) # populate the table with the number of cards expected for a 1 round tie
    round_result = WarRoundResult.new(table_cards, players)
    final_card_count = (WarGame::EXTRA_TIE_CARDS * 2) + 2
    expect(round_result.description).to eq "Both play #{tied_cards.first.rank}! Each player adds #{WarGame::EXTRA_TIE_CARDS} more cards. There are #{final_card_count} cards on the table."
  end

  context 'best and worst cards' do
    let(:round_result) { WarRoundResult.new(player_2_wins_cards, players) }
    let(:best_card) { MockPlayingCard.new('10') }
    let(:loser_card) { MockPlayingCard.new('3') }

    it 'returns the losing card when player 1 loses the round' do
      expect(round_result.worse_card(loser_card, best_card)).to eq loser_card
    end

    it 'returns the losing card when player 2 loses the round' do
      expect(round_result.worse_card(best_card, loser_card)).to eq loser_card
    end

    it 'returns nil for the losing card when there is a tie' do
      expect(round_result.worse_card(best_card, best_card)).to eq nil
    end

    it 'returns the winning card when player 1 wins the round' do
      expect(round_result.better_card(player_1_wins_cards.first, player_1_wins_cards.last)).to eq player_1_wins_cards.first
    end

    it 'returns the winning card when player 2 wins the round' do
      expect(round_result.better_card(best_card, loser_card)).to eq best_card
    end

    it 'returns nil for the winning card when there is a tie' do
      expect(round_result.better_card(best_card, best_card)).to eq nil
    end
  end

  it 'returns the correct value for letter cards' do
    round_result = WarRoundResult.new(player_1_wins_cards, players)
    expect(round_result.value_card(MockPlayingCard.new('J'))).to eq 11
    expect(round_result.value_card(MockPlayingCard.new('Q'))).to eq 12
    expect(round_result.value_card(MockPlayingCard.new('K'))).to eq 13
    expect(round_result.value_card(MockPlayingCard.new('A'))).to eq 14
  end

  it 'returns the correct value for number cards' do
    round_result = WarRoundResult.new(player_1_wins_cards, players)
    (2..10).each do |number|
      expect(round_result.value_card(MockPlayingCard.new(number.to_s))).to eq number
    end
  end
end
