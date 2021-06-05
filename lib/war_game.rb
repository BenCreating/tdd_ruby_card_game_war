require_relative 'war_player'
require_relative 'card_deck'
require_relative 'shuffling_deck'
require_relative 'war_round_result'

class WarGame
  attr_reader :players

  EXTRA_TIE_CARDS = 3

  def start(deck: ShufflingDeck.new, player_1: WarPlayer.new(name: 'Alice', cards: CardDeck.new([])), player_2: WarPlayer.new(name: 'Bob', cards: CardDeck.new([])))
    @players = [player_1, player_2]
    deck.shuffle
    deal_game_cards(deck)
  end

  def play_round(table_cards = [])
    player_1_card = players.first.play_card
    player_2_card = players.last.play_card
    table_cards << player_1_card << player_2_card
    round_result = WarRoundResult.new(player_1_card, player_2_card, players, table_cards.count)
    award_cards_to_winner(round_result.winner, table_cards)
    round_result.description
  end

  def winner
    players_still_in_game = []
    players.each do |player|
      players_still_in_game << player if player.card_count > 0
    end

    return players_still_in_game.pop if players_still_in_game.count == 1
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
    if player
      table_cards = mix_up_cards(table_cards)
      table_cards.count.times do
        card = table_cards.pop
        player.pick_up_card(card)
      end
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
