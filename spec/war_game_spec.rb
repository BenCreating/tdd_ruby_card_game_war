require_relative '../lib/war_game'
require_relative '../lib/card_deck'
require_relative '../lib/shuffling_deck'
require_relative '../lib/playing_card'

class PlayerHolder
  attr_reader :player_1
  attr_reader :player_2

  def initialize(name1: 'Player 1', name2: 'Player 2', cards1: [], cards2: [])
    @player_1 = create_player(name1, cards1)
    @player_2 = create_player(name2, cards2)
  end

  def create_player(name = 'Anonymous', card_ranks = [])
    cards = create_cards(card_ranks)
    WarPlayer.new(name: name, cards: CardDeck.new(cards))
  end

  def create_cards(card_ranks = [])
    cards = []
    card_ranks.each do |rank|
      cards << PlayingCard.new(rank)
    end
    cards
  end
end

describe 'WarGame' do
  let(:game) { WarGame.new }

  context 'start' do
    it 'returns an array of the players' do
      game.start
      expect(game.players.count).to eq 2
    end

    it 'deals cards to the players' do
      game.start
      player_card_count = game.players.first.card_count
      expect(player_card_count).to eq 26
    end

    it 'starts a game with a specified deck' do
      deck = ShufflingDeck.new([PlayingCard.new('A'), PlayingCard.new('2')])
      game.start(deck: deck)
      expect([game.players.first.play_card.rank, game.players.last.play_card.rank]).to match_array ['A', '2']
      deck2 = ShufflingDeck.new([PlayingCard.new('J'), PlayingCard.new('Q')])
      game.start(deck: deck2)
      expect([game.players.first.play_card.rank, game.players.last.play_card.rank]).to match_array ['J', 'Q']
    end

    it 'starts the game with specified player hands' do
      players = PlayerHolder.new(cards1: ['3'], cards2: ['K'])
      game.start(player_1: players.player_1, player_2: players.player_2)
      expect(game.players.first.play_card.rank).to eq '3'
      expect(game.players.last.play_card.rank).to eq 'K'

      players2 = PlayerHolder.new(cards1: ['10'], cards2: ['5'])
      game.start(player_1: players2.player_1, player_2: players2.player_2)
      expect(game.players.first.play_card.rank).to eq '10'
      expect(game.players.last.play_card.rank).to eq '5'
    end

    it 'starts the game with specified player names' do
      deck = ShufflingDeck.new
      players = PlayerHolder.new()
      game.start(deck: deck, player_1: players.player_1, player_2: players.player_2)
      expect(game.players.first.name).to eq 'Player 1'
      expect(game.players.last.name).to eq 'Player 2'
    end
  end

  context 'play_round' do
    let(:deck) { ShufflingDeck.new([]) }
    it 'each player plays a card, player 1 wins and takes the cards' do
      players = PlayerHolder.new(cards1: ['K'], cards2: ['2'])
      game.start(deck: deck, player_1: players.player_1, player_2: players.player_2)
      game.play_round
      expect(game.players.first.card_count).to eq 2
      expect(game.players.last.card_count).to eq 0
    end

    it 'each player plays a card, player 2 wins and takes the cards' do
      players = PlayerHolder.new(cards1: ['5'], cards2: ['10'])
      game.start(deck: deck, player_1: players.player_1, player_2: players.player_2)
      game.play_round
      expect(game.players.first.card_count).to eq 0
      expect(game.players.last.card_count).to eq 2
    end

    it 'returns a string describing a normal round' do
      players = PlayerHolder.new(cards1: ['10'], cards2: ['2'])
      game.start(deck: deck, player_1: players.player_1, player_2: players.player_2)
      winner = game.players.first.name
      winner_card = '10'
      loser_card = '2'
      expect(game.play_round).to eq "Player #{winner} beat #{loser_card} with #{winner_card}"
    end

    it 'returns a string describing a tied round' do
      players = PlayerHolder.new(cards1: ['5'], cards2: ['5'])
      game.start(deck: deck, player_1: players.player_1, player_2: players.player_2)
      expect(game.play_round).to eq "Both play 5! There are 2 cards on the table."
    end

    context 'tie games' do
      let(:deck) { ShufflingDeck.new([]) }
      let(:tie_cards) { ['9', '6', '4', '2', '5', '3', '7', 'J'] }
      let(:winning_cards) { ['6', 'K'] }
      let(:losing_cards) { ['8', '2'] }

      it 'the rounds tie until player 1 wins and takes all the cards' do
        players = PlayerHolder.new(cards1: winning_cards + tie_cards, cards2: losing_cards + tie_cards)
        game.start(deck: deck, player_1: players.player_1, player_2: players.player_2)
        3.times { game.play_round }
        expect(game.players.first.card_count).to eq 19
        expect(game.players.last.card_count).to eq 1
      end

      it 'the rounds tie until player 2 wins and takes all the cards' do
        players = PlayerHolder.new(cards1: losing_cards + tie_cards, cards2: winning_cards + tie_cards)
        game.start(deck: deck, player_1: players.player_1, player_2: players.player_2)
        3.times { game.play_round }
        expect(game.players.first.card_count).to eq 1
        expect(game.players.last.card_count).to eq 19
      end

      it 'the players drop the correct number of cards for a tie' do
        players = PlayerHolder.new(cards1: winning_cards + tie_cards, cards2: losing_cards + tie_cards)
        game.start(deck: deck, player_1: players.player_1, player_2: players.player_2)
        game.play_round
        expect(game.players.first.card_count).to eq 6
        expect(game.players.last.card_count).to eq 6
      end
    end
  end

  context 'winner' do
    let(:deck) { ShufflingDeck.new([]) }
    let(:winning_cards) { ['A', '6'] }
    let(:losing_cards) { ['K', '3'] }

    it 'reports nil when no player has won the game' do
      players = PlayerHolder.new(cards1: winning_cards, cards2: losing_cards)
      game.start(deck: deck, player_1: players.player_1, player_2: players.player_2)
      game.play_round
      expect(game.winner).to be_nil
    end

    it 'reports that player 1 has won' do
      players = PlayerHolder.new(cards1: winning_cards, cards2: losing_cards)
      game.start(deck: deck, player_1: players.player_1, player_2: players.player_2)
      2.times { game.play_round }
      expect(game.winner).to eq game.players.first
    end

    it 'reports that player 2 has won' do
      players = PlayerHolder.new(cards1: losing_cards, cards2: winning_cards)
      game.start(deck: deck, player_1: players.player_1, player_2: players.player_2)
      2.times { game.play_round }
      expect(game.winner).to eq game.players.last
    end
  end

  it 'changes the order of the cards to avoid a loop' do
    mixed_cards = game.mix_up_cards([PlayingCard.new('2'), PlayingCard.new('3')])
    expect(mixed_cards.first.rank).to eq '3'
    expect(mixed_cards.last.rank).to eq '2'
  end
end
