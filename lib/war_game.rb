require_relative 'war_player'
require_relative 'card_deck'
require_relative 'shuffling_deck'
require_relative 'war_round_result'

class WarGame
  attr_reader :players, :table_cards, :deck

  def start(deck: ShufflingDeck.new, player_1: WarPlayer.new(name: 'Alice', cards: CardDeck.new([])), player_2: WarPlayer.new(name: 'Bob', cards: CardDeck.new([])))
    @deck = deck
    @players = [player_1, player_2]
    @table_cards = []
    deal_game_cards()
  end

  def deck_card_count
    deck.cards_left
  end

  def play_round
    player_1_card = players.first.play_card
    player_2_card = players.last.play_card
    table_cards << player_1_card << player_2_card
    best_card = better_card(player_1_card, player_2_card)
    round_result = WarRoundResult.new(best_card, player_1_card, player_2_card, players, table_cards.count)
    award_cards_to_winner(round_result.winner)
    round_result.description
  end

  def winner
    players_still_in_game = []
    players.each do |player|
      players_still_in_game << player if player.card_count > 0
    end

    return players_still_in_game.pop if players_still_in_game.count == 1
  end

  def deal_game_cards
    cards_per_player = deck.cards_left/players.count
    players.each do |player|
      cards_per_player.times do
        card = deck.deal
        player.pick_up_card(card)
      end
    end
  end

  def better_card(card1, card2)
    value1 = value_card(card1)
    value2 = value_card(card2)
    if value1 > value2
      card1
    elsif value2 > value1
      card2
    end
  end

  def value_card(card)
    if ['A', 'J', 'Q', 'K'].include?(card.rank)
      {'J' => 11, 'Q' => 12, 'K' => 13, 'A' => 14}.fetch(card.rank)
    else
      card.rank.to_i
    end
  end

  def award_cards_to_winner(player)
    if player
      table_cards.count.times { player.pick_up_card(table_cards.pop) }
    end
  end

  def mix_up_cards(cards)
    mixed_cards = cards.shuffle
    # in the rare case that the order is the same, move one from the beginning to the end
    if mixed_cards = cards
      card = mixed_cards.shift
      mixed_cards.push(card)
    end
  end
end
