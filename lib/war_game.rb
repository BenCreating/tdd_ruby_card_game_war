require_relative 'war_player'
require_relative 'card_deck'
require_relative 'shuffling_deck'
require_relative 'war_round_result'

class WarGame
  attr_reader :players
  attr_accessor :last_round_table_cards

  EXTRA_TIE_CARDS = 3

  def start(deck: ShufflingDeck.new, player_1: WarPlayer.new(name: 'Alice', cards: CardDeck.new([])), player_2: WarPlayer.new(name: 'Bob', cards: CardDeck.new([])))
    @players = [player_1, player_2]
    @last_round_table_cards = []
    deck.shuffle
    deal_game_cards(deck)
  end

  def play_round
    table_cards = play_all_round_cards()
    self.last_round_table_cards = table_cards
    round_result = WarRoundResult.new(table_cards, players)
    award_cards_to_winner(round_result.winner, table_cards)
    round_result.description
  end

  def play_all_round_cards
    first_cards = [players.first.play_card, players.last.play_card]
    round_cards = []
    if first_cards[0].rank == first_cards[1].rank
      EXTRA_TIE_CARDS.times { round_cards = round_cards + [players.first.play_card, players.last.play_card] }
    end
    # put the first cards on the end so if there were already cards on the table we can find the cards that were compared in this round
    last_round_table_cards + round_cards + first_cards
  end

  def winner
    players_still_in_game = []
    players.each do |player|
      players_still_in_game << player if player.card_count > 0
    end

    return players_still_in_game.pop if players_still_in_game.count == 1
  end

  def loser
    losing_player = nil
    if winner()
      players.each do |player|
        losing_player = player if player.card_count == 0
      end
    end
    losing_player
  end

  def deal_game_cards(deck)
    cards_per_player = deck.cards_left/players.count
    players.each do |player|
      cards_per_player.times do
        card = deck.deal
        player.pick_up_card(card)
      end
    end
  end

  def award_cards_to_winner(player, table_cards)
    if player # make sure it wasn't a tie
      table_cards = mix_up_cards(table_cards)
      table_cards.count.times do
        player.pick_up_card(table_cards.pop)
      end
      self.last_round_table_cards = []
    end
  end

  def mix_up_cards(cards)
    mixed_cards = cards.shuffle
    # in the rare case that the order is the same, move one from the beginning to the end
    if mixed_cards = cards
      card = mixed_cards.shift
      mixed_cards.push(card)
    end
    mixed_cards
  end
end
