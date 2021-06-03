require_relative '../lib/war_game'
require_relative '../lib/card_deck'
require_relative '../lib/shuffling_deck'
require_relative '../lib/playing_card'

describe 'WarGame' do
  let(:game) { WarGame.new }

  def create_player(name = 'Anonymous', card_ranks = [])
    create_cards(card_ranks)
    WarPlayer.new(name: name, cards: CardDeck.new(cards))
  end

  def create_cards(card_ranks = [])
    cards = []
    card_ranks.each do |rank|
      cards << PlayingCard.new(rank)
    end
    cards
  end

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
      player_1 = WarPlayer.new(cards: CardDeck.new([PlayingCard.new('3')]))
      player_2 = WarPlayer.new(cards: CardDeck.new([PlayingCard.new('K')]))
      game.start(deck: deck, player_1: player_1, player_2: player_2)
      expect(game.players.first.play_card.rank).to eq '3'
      expect(game.players.last.play_card.rank).to eq 'K'
      player_1b = WarPlayer.new(cards: CardDeck.new([PlayingCard.new('10')]))
      player_2b = WarPlayer.new(cards: CardDeck.new([PlayingCard.new('5')]))
      game.start(deck: deck, player_1: player_1, player_1: player_2)
      expect(game.players.first.play_card.rank).to eq '10'
      expect(game.players.last.play_card.rank).to eq '5'
    end

    it 'starts the game with specified player names' do
      deck = ShufflingDeck.new
      hand1 = CardDeck.new([])
      hand2 = CardDeck.new([])
      player_1_name = 'Player 1'
      player_2_name = 'Player 2'
      game.start(deck, hand1, hand2, player_1_name, player_2_name)
      expect(game.players.first.name).to eq player_1_name
      expect(game.players.last.name).to eq player_2_name
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

    it 'returns a string describing a normal round' do
      player1_hand = CardDeck.new([PlayingCard.new('10')])
      player2_hand = CardDeck.new([PlayingCard.new('2')])
      game.start(deck, player1_hand, player2_hand)
      winner = game.players.first.name
      winner_card = '10'
      loser_card = '2'
      expect(game.play_round).to eq "Player #{winner} beat #{loser_card} with #{winner_card}"
    end

    it 'returns a string describing a tied round' do
      player1_hand = CardDeck.new([PlayingCard.new('5')])
      player2_hand = CardDeck.new([PlayingCard.new('5')])
      game.start(deck, player1_hand, player2_hand)
      expect(game.play_round).to eq "Both play 5! There are 2 cards on the table."
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

    it 'reports that player 1 has won' do
      game.start(deck, winning_hand, losing_hand)
      game.play_round
      game.play_round
      expect(game.winner).to eq game.players.first
    end

    it 'reports that player 2 has won' do
      game.start(deck, losing_hand, winning_hand)
      game.play_round
      game.play_round
      expect(game.winner).to eq game.players.last
    end
  end

  it 'starts a game for a server' do
    player_1 = WarPlayer.new
    player_2 = WarPlayer.new
    game.start_server_game(player_1, player_2)
    expect(game.players.count).to eq 2
  end

  it 'returns the player clients' do
    # these will be object,s but I don't care what they are for this test
    client1 = 'player 1 client'
    client2 = 'player 1 client'

    game.start(ShufflingDeck.new, CardDeck.new, CardDeck.new, 'Alice', 'Bob', client1, client2)
    expect(game.player_1_client).to eq client1
    expect(game.player_2_client).to eq client2
  end
end
