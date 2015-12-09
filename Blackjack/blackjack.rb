# Blackjack assignment for Tealeaf Lesson 2

require './gameparameters'
require './player'
require './cards'
require './cardgame'
require './gameengine'

class Dealer < Player
  def initialize
    super(name: "Dealer")
  end

  def hand
    hands[0]
  end
end

class BlackjackGame < CardGame
  @@options = { 'h' => 'Hit', 's' => 'Stay' }
  @@split = { 'x' => 'Split' }

  attr_accessor :surviving_hands
  attr_reader :dealer

  def initialize(players: [Human.new], num_decks: 1)
    super(players: players, num_decks: num_decks, num_hands: 1, num_cards: 2)
    @dealer = Dealer.new
    dealer.new_hand
    dealer.hand.add(shoe.deal(2))
    surviving_hands = []
  end

  def score_hand(hand)
    cards = hand.cards
    total = 0
    number_of_aces = 0

    cards.each do |card|
      if card.name == "A"
        number_of_aces += 1
      end

      total += GameParameters.card_value(card)
    end

    while total > 21 && number_of_aces > 0
      number_of_aces -= 1
      total -= 10
    end
    total
  end

  def dealer_turn
    hand = dealer.hand
    dealer_score = score_hand(hand)

    blackjack?(hand)

    GameEngine.clear_screen

    puts "The dealer has:"
    hand.display

    puts "Total: #{dealer_score}"
    puts
    sleep 0.8

    if hand.status == :blackjack
      puts "Dealer has Blackjack!"
    elsif dealer_score < 17
      puts "Dealer hits!"
      GameEngine.heighten_suspense
      hit(hand)
    elsif dealer_score >= 17 && dealer_score <= 21
      puts "Dealer stays."
      stay(hand)
    else
      bust(hand)
    end
  end

  def hit(hand)
    cards = shoe.deal(1)
    cards.each do |card|
      hand.add(card)
    end
  end

  def stay(hand)
    hand.status = :stay
  end

  def split(player, hand)
    split_card = hand.delete(1)[0]
    hand.add(shoe.deal(1))
    player.new_hand(split_card, shoe.deal(1))
  end

  def bust(hand)
    hand.status = :bust
  end

  def blackjack?(hand)
    if hand.cards.length == 2 && score_hand(hand) == 21
      hand.status = :blackjack
    end
  end

  def eligible_options(hand)
    options = [@@options]
    if hand.cards.length == 2 &&
       GameParameters.card_value(hand.cards[0]) == GameParameters.card_value(hand.cards[1])

      options << @@split
    end
    options
  end

  def display_in_play(player, hand)
    GameEngine.clear_screen
    puts "The dealer has:"
    dealer.hand.display(hide: 1)
    puts
    puts "#{player.name}, your turn!"
    puts "You have:"
    hand.display
    puts "Total: #{score_hand(hand)}"
    puts
  end

  def score_game
    puts
    if dealer.hand.status == :bust
      puts "Dealer is bust!"
      puts
      sleep 1.2
      surviving_hands.each { |hand| puts "#{hand[0]} wins!" }
    else
      surviving_hands.each do |survivor|
        player_score = score_hand(survivor[1])
        status = survivor[1].status
        dealer_score = score_hand(dealer.hand)
        name = survivor[0]
        if status == :blackjack && dealer.hand.status != :blackjack
          puts "#{name} wins, with Blackjack!"
        elsif  player_score > dealer_score
          puts "#{name} wins! (#{player_score} beats #{dealer_score})"
        elsif player_score == dealer_score
          puts "#{name} ties with the dealer!"
        else
          puts "Dealer beats #{name}, #{dealer_score} to #{player_score}!"
        end
      end
      puts
    end
  end

  def player_turn(player)
    while hand = player.get_hand_with_status(:active) # Deliberate

      blackjack?(hand)

      while hand.status == :active

        display_in_play(player, hand)

        choice = player.get_choice(eligible_options(hand))

        if choice == 'h'
          GameEngine.heighten_suspense
          hit(hand)
        elsif choice == 's'
          stay(hand)
        elsif choice == 'x'
          split(player, hand)
        end

        if score_hand(hand) > 21
          bust(hand)
        end
      end

      if hand.status == :stay
        surviving_hands << [player.name, hand]
      elsif hand.status == :bust
        display_in_play(player, hand)
        puts "Bust!"
        puts
        GameEngine.wait_to_continue
      elsif hand.status == :blackjack
        surviving_hands << [player.name, hand]
        display_in_play(player, hand)
        GameEngine.heighten_suspense
        puts
        puts "Blackjack!"
        puts
        GameEngine.wait_to_continue
      end

      player.fold_hand(hand)
      GameEngine.clear_screen
    end
  end

  def play
    players.each do |player|
      player_turn(player)
    end

    if surviving_hands.length > 0
      while dealer.hand.status == :active
        dealer_turn
      end
    end

    score_game
  end
end

GameEngine.new.play
