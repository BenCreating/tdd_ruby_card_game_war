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
    it 'each player plays a card, player 1 wins' do
      deck = ShufflingDeck.new([PlayingCard.new('K'), PlayingCard.new('2')])
      game.start(deck)
      game.play_round
      expect(game.players.first.card_count).to eq 2
      expect(game.players.last.card_count).to eq 0
    end

    it 'each player plays a card, player 2 wins' do
      deck = ShufflingDeck.new([PlayingCard.new('2'), PlayingCard.new('J')])
      game.start(deck)
      game.play_round
      expect(game.players.first.card_count).to eq 0
      expect(game.players.last.card_count).to eq 2
    end

    it 'each player plays a card, it is a tie' do
      # fill this in
    end
  end
end
