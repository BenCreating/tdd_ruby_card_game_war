require_relative '../lib/war_game'
require_relative '../lib/card_deck'
require_relative '../lib/shuffling_deck'
require_relative '../lib/playing_card'

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
      game.start(deck)
      expect([game.players.first.play_card.rank, game.players.last.play_card.rank]).to match_array ['A', '2']
      deck2 = ShufflingDeck.new([PlayingCard.new('J'), PlayingCard.new('Q')])
      game.start(deck2)
      expect([game.players.first.play_card.rank, game.players.last.play_card.rank]).to match_array ['J', 'Q']
    end

    it 'starts the game with specified player hands' do
      deck = ShufflingDeck.new([])
      player1_hand = CardDeck.new([PlayingCard.new('3')])
      player2_hand = CardDeck.new([PlayingCard.new('K')])
      game.start(deck, player1_hand, player2_hand)
      expect(game.players.first.play_card.rank).to eq '3'
      expect(game.players.last.play_card.rank).to eq 'K'
      player1_hand2 = CardDeck.new([PlayingCard.new('10')])
      player2_hand2 = CardDeck.new([PlayingCard.new('5')])
      game.start(deck, player1_hand2, player2_hand2)
      expect(game.players.first.play_card.rank).to eq '10'
      expect(game.players.last.play_card.rank).to eq '5'
    end
  end

  context 'play_round' do
    let(:deck) { ShufflingDeck.new([]) }
    it 'each player plays a card, player 1 wins and takes the cards' do
      player1_hand = CardDeck.new([PlayingCard.new('K')])
      player2_hand = CardDeck.new([PlayingCard.new('2')])
      game.start(deck, player1_hand, player2_hand)
      game.play_round
      expect(game.players.first.card_count).to eq 2
      expect(game.players.last.card_count).to eq 0
    end

    it 'each player plays a card, player 2 wins and takes the cards' do
      player1_hand = CardDeck.new([PlayingCard.new('5')])
      player2_hand = CardDeck.new([PlayingCard.new('10')])
      game.start(deck, player1_hand, player2_hand)
      game.play_round
      expect(game.players.first.card_count).to eq 0
      expect(game.players.last.card_count).to eq 2
    end

    context 'tie games' do
      let(:tie_cards) { [PlayingCard.new('7'), PlayingCard.new('J')] }
      let(:winning_cards) { [PlayingCard.new('6'), PlayingCard.new('K')] }
      let(:losing_cards) { [PlayingCard.new('8'), PlayingCard.new('2')] }
      it 'the rounds tie until player 1 wins and takes all the cards' do
        player1_hand = CardDeck.new(winning_cards + tie_cards)
        player2_hand = CardDeck.new(losing_cards + tie_cards)
        game.start(deck, player1_hand, player2_hand)
        game.play_round
        expect(game.table_cards.count).to eq 2
        game.play_round
        expect(game.table_cards.count).to eq 4
        game.play_round
        expect(game.table_cards.count).to eq 0
        expect(game.players.first.card_count).to eq 7
        expect(game.players.last.card_count).to eq 1
      end

      it 'the rounds tie until player 2 wins and takes all the cards' do
        player1_hand = CardDeck.new(losing_cards + tie_cards)
        player2_hand = CardDeck.new(winning_cards + tie_cards)
        game.start(deck, player1_hand, player2_hand)
        game.play_round
        expect(game.table_cards.count).to eq 2
        game.play_round
        expect(game.table_cards.count).to eq 4
        game.play_round
        expect(game.table_cards.count).to eq 0
        expect(game.players.first.card_count).to eq 1
        expect(game.players.last.card_count).to eq 7
      end
    end
  end

  context 'winner' do
    let(:deck) { ShufflingDeck.new([]) }
    let(:winning_hand) { CardDeck.new([PlayingCard.new('A'), PlayingCard.new('6')]) }
    let(:losing_hand) { CardDeck.new([PlayingCard.new('K'), PlayingCard.new('3')]) }
    it 'reports nil when no player has won the game' do
      game.start(deck, winning_hand, losing_hand)
      game.play_round
      expect(game.winner).to be_nil
    end
  end
end
