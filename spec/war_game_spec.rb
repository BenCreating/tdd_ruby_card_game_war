require_relative '../lib/war_game'
require_relative '../lib/card_deck'
require_relative '../lib/shuffling_deck'
require_relative '../lib/playing_card'

describe 'WarGame' do
  let(:game) { WarGame.new }

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
      deck = ShufflingDeck.new(create_cards(['A', '2']))
      game.start(deck: deck)
      expect([game.players.first.play_card.rank, game.players.last.play_card.rank]).to match_array ['A', '2']
      deck2 = ShufflingDeck.new(create_cards(['J', 'Q']))
      game.start(deck: deck2)
      expect([game.players.first.play_card.rank, game.players.last.play_card.rank]).to match_array ['J', 'Q']
    end

    it 'starts the game with specified player hands' do
      player_1 = create_player('Player 1', ['3'])
      player_2 = create_player('Player 2', ['K'])
      game.start(player_1: player_1, player_2: player_2)
      expect(game.players.first.play_card.rank).to eq '3'
      expect(game.players.last.play_card.rank).to eq 'K'

      player_1b = create_player('Player 1b', ['10'])
      player_2b = create_player('Player 2b', ['5'])
      game.start(player_1: player_1b, player_2: player_2b)
      expect(game.players.first.play_card.rank).to eq '10'
      expect(game.players.last.play_card.rank).to eq '5'
    end

    it 'starts the game with specified player names' do
      deck = ShufflingDeck.new
      hand1 = CardDeck.new([])
      hand2 = CardDeck.new([])
      player_1 = create_player('Player 1')
      player_2 = create_player('Player 2')
      game.start(deck: deck, player_1: player_1, player_2: player_2)
      expect(game.players.first.name).to eq 'Player 1'
      expect(game.players.last.name).to eq 'Player 2'
    end
  end

  context 'play_round' do
    let(:deck) { ShufflingDeck.new([]) }
    it 'each player plays a card, player 1 wins and takes the cards' do
      player_1 = create_player('Player 1', ['K'])
      player_2 = create_player('Player 2', ['2'])
      game.start(deck: deck, player_1: player_1, player_2: player_2)
      game.play_round
      expect(game.players.first.card_count).to eq 2
      expect(game.players.last.card_count).to eq 0
    end

    it 'each player plays a card, player 2 wins and takes the cards' do
      player_1 = create_player('Player 1', ['5'])
      player_2 = create_player('Player 2', ['10'])
      game.start(deck: deck, player_1: player_1, player_2: player_2)
      game.play_round
      expect(game.players.first.card_count).to eq 0
      expect(game.players.last.card_count).to eq 2
    end

    it 'returns a string describing a normal round' do
      player_1 = create_player('Player 1', ['10'])
      player_2 = create_player('Player 2', ['2'])
      game.start(deck: deck, player_1: player_1, player_2: player_2)
      winner = game.players.first.name
      winner_card = '10'
      loser_card = '2'
      expect(game.play_round).to eq "Player #{winner} beat #{loser_card} with #{winner_card}"
    end

    it 'returns a string describing a tied round' do
      player_1 = create_player('Player 1', ['5'])
      player_2 = create_player('Player 2', ['5'])
      game.start(deck: deck, player_1: player_1, player_2: player_2)
      expect(game.play_round).to eq "Both play 5! There are 2 cards on the table."
    end

    context 'tie games' do
      let(:deck) { ShufflingDeck.new([]) }
      let(:tie_cards) { ['7', 'J'] }
      let(:winning_cards) { ['6', 'K'] }
      let(:losing_cards) { ['8', '2'] }

      it 'the rounds tie until player 1 wins and takes all the cards' do
        player_1 = create_player('Player 1', winning_cards + tie_cards)
        player_2 = create_player('Player 2', losing_cards + tie_cards)
        game.start(deck: deck, player_1: player_1, player_2: player_2)
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
        player_1 = create_player('Player 1', losing_cards + tie_cards)
        player_2 = create_player('Player 2', winning_cards + tie_cards)
        game.start(deck: deck, player_1: player_1, player_2: player_2)
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
    let(:winning_player) { create_player('Winner', ['A', '6']) }
    let(:losing_player) { create_player('Loser', ['K', '3']) }

    it 'reports nil when no player has won the game' do
      game.start(deck: deck, player_1: winning_player, player_2: losing_player)
      game.play_round
      expect(game.winner).to be_nil
    end

    it 'reports that player 1 has won' do
      game.start(deck: deck, player_1: winning_player, player_2: losing_player)
      2.times { game.play_round }
      expect(game.winner).to eq game.players.first
    end

    it 'reports that player 2 has won' do
      game.start(deck: deck, player_1: losing_player, player_2: winning_player)
      2.times { game.play_round }
      expect(game.winner).to eq game.players.last
    end
  end

  it 'starts a game for a server' do
    player_1 = WarPlayer.new
    player_2 = WarPlayer.new
    game.start_server_game(player_1, player_2)
    expect(game.players.count).to eq 2
  end
end
