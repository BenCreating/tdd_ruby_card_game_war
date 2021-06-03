require_relative 'war_player'
require_relative 'card_deck'
require_relative 'shuffling_deck'

class WarGame
  attr_reader :players
  attr_reader :table_cards

  def start(deck = ShufflingDeck.new, hand1 = CardDeck.new([]), hand2 = CardDeck.new([]), player_1_name = 'Alice', player_2_name = 'Bob', player_1_client = nil, player_2_client = nil)
    @deck = deck
    @players = [WarPlayer.new(name: player_1_name, cards: hand1), WarPlayer.new(name: player_2_name, cards: hand2)]

    deal_game_cards()
  end

  def start_server_game(player_1, player_2)
    @deck = ShufflingDeck.new
    @players = [player_1, player_2]

    deal_game_cards()
  end

  def deck_card_count
    @deck.cards_left
  end

  def play_round
    player_1_card = @players.first.play_card
    player_2_card = @players.last.play_card

    @table_cards << player_1_card << player_2_card
    best_card = better_card(player_1_card, player_2_card)
    if best_card == player_1_card
      award_cards_to_winner(@players.first)
      winner = @players.first.name
      loser_card = player_2_card.rank
    elsif best_card == player_2_card
      award_cards_to_winner(@players.last)
      winner = @players.last.name
      loser_card = player_1_card.rank
    end

    if best_card
      "Player #{winner} beat #{loser_card} with #{best_card.rank}"
    else
      "Both play #{player_1_card.rank}! There are #{@table_cards.count} cards on the table."
    end
  end

  def winner
    players_still_in_game = []
    @players.each do |player|
      players_still_in_game << player if player.card_count > 0
    end

    return players_still_in_game.pop if players_still_in_game.count == 1
  end

  private

    def deal_game_cards
      @deck.shuffle
      (@deck.cards_left/2).times do
        card = @deck.deal
        @players.first.pick_up_card(card)
      end
      @deck.cards_left.times do
        card = @deck.deal
        @players.last.pick_up_card(card)
      end

      @table_cards = []
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
      @table_cards.count.times do
        card = @table_cards.pop
        player.pick_up_card(card)
      end
    end
end
