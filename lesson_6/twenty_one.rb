# require 'pry'
# ACE_COMBOS contains all possible ace summations under 22.
# For example, if player draws 2 aces in a single hand those aces
# can add up to 22, 12 or 2. But since 22 is greater than 21,
# ACE_COMBOS returns an array containing only 12 and 2.

CHAMPION_WINS = 3
ACE_COMBOS = {
  0 => [0],
  1 => [11, 1],
  2 => [12, 2],
  3 => [13, 3],
  4 => [14, 4]
}

def prompt(msg)
  puts "=> #{msg}"
end

def pause(seconds)
  sleep(seconds)
end

def intro_message
  key = nil
  loop do
    prompt "Welcome to Twenty-One!"
    pause(1)
    prompt "You'll be playing 3 rounds against the Dealer"
    pause(2)
    prompt "First player to win 3 rounds wins the GAME!"
    pause(2)
    prompt "Press the ENTER or RETURN key to get started"
    key = gets.chomp
    break if !key.nil?
  end
end

def initialize_deck
  deck = {}
  suits = ["Spades", "Clubs", "Hearts", "Diamonds"]
  suits.each do |suit|
    deck[suit] = ["Ace", 2, 3, 4, 5, 6, 7, 8, 9, 10, "Jack", "Queen", "King"]
  end
  deck
end

def update_dealt_cards(plyr_hand, dlr_hand, current)
  cards = if current == "You"
            [card_nums(plyr_hand), "#{dlr_hand[0][0]} and ?"]
          else
            [card_nums(plyr_hand), card_nums(dlr_hand)]
          end
  display_dealt(cards)
end

def card_nums(hand)
  hand.map { |card| card[0] }.join(", ")
end

def display_dealt(cards)
  system 'clear'
  prompt "**************** DEALT CARDS ****************"
  prompt "Player Cards: #{cards[0]}"
  prompt "Dealer Cards: #{cards[1]}"
  prompt "*********************************************"
end

def deal_card(deck)
  suit = deck.keys.sample
  number = deck[suit].sample
  card = [number, suit]
  deck[suit].delete(number)
  card
end

def deal_initial_cards(deck, plyr_hand, dlr_hand)
  2.times { plyr_hand << deal_card(deck) }
  2.times { dlr_hand << deal_card(deck) }
end

def show_initial_cards(plyr_hand, dlr_hand, total)
  prompt ""
  prompt "Your first two cards are:"
  prompt "The #{plyr_hand[0][0]} of #{plyr_hand[0][1]}"
  prompt "The #{plyr_hand[1][0]} of #{plyr_hand[1][1]}"
  prompt "You're at #{total[0]}"
  prompt ""

  num, suit = dlr_hand.first
  prompt "Dealer has: The #{num} of #{suit} and ?"
end

def show(hand, current)
  prompt ""
  prompt "#{current} drew the #{hand.last[0]} of #{hand.last[1]}"
end

def display_total(current, total)
  pause(2)
  if current == "You"
    prompt "You're at #{total[0]}"
  else
    prompt "Dealer's at #{total[0]}"
  end
  pause(2)
end

def calculate_total(hand)
  total = 0
  aces = 0

  hand.each do |card|
    if card[0] == "Ace"
      aces += 1
    elsif card[0].is_a?(String)
      total += 10
    else
      total += card[0]
    end
  end

  total_with_aces = calc_total_with_aces(aces, total)
  aces > 0 ? total_with_aces : total
end

def calc_total_with_aces(aces, total)
  possible_totals = []
  ACE_COMBOS[aces].each { |num| possible_totals << total + num }

  losers, winners = possible_totals.partition do |num|
    num > 21
  end

  winners.empty? ? losers.min : winners.max
end

def busted?(total)
  total[0] > 21
end

def player_turn(deck, plyr_hand, dlr_hand, total, current)
  choice = nil
  loop do
    choice = retrieve_player_choice
    break if choice.downcase.start_with?('s')

    prompt ""
    prompt "You chose to hit"
    pause(2)

    plyr_hand << deal_card(deck)
    total[0] = calculate_total(plyr_hand)
    update_dealt_cards(plyr_hand, dlr_hand, current)
    show(plyr_hand, current)
    break if busted?(total)
    display_total(current, total)
  end
  declare_player_result(choice, current, total)
end

def retrieve_player_choice
  choice = nil
  prompt ""
  prompt "Would you like to hit or stay? 'h' = 'Hit', 's' = 'Stay'"

  loop do
    choice = gets.chomp
    break if valid?(choice)
    prompt "Please type 'H' = 'Hit', 'S' = 'Stay'"
  end
  choice
end

def valid?(choice)
  choice.downcase.start_with?('h') || choice.downcase.start_with?('s')
end

def declare_player_result(choice, current, total)
  if choice.downcase.start_with?('s')
    prompt "You chose to stay"
    pause(2)
  elsif busted?(total)
    declare_bust(current, total)
  end
end

def dealer_turn(deck, dlr_hand, plyr_hand, current, total)
  prompt "Dealer currently has:"
  prompt "The #{dlr_hand[0][0]} of #{dlr_hand[0][1]}"
  prompt "The #{dlr_hand[1][0]} of #{dlr_hand[1][1]}"
  display_total(current, total)

  if total[0] >= 17
    prompt "Dealer will stay"
    pause(2)
  else
    dealer_continues_to_hit(deck, dlr_hand, plyr_hand, current, total)
  end
end

def dealer_continues_to_hit(deck, dlr_hand, plyr_hand, current, total)
  loop do
    dlr_hand << deal_card(deck)
    total[0] = calculate_total(dlr_hand)
    prompt "Dealer will hit"
    pause(2)
    update_dealt_cards(plyr_hand, dlr_hand, current)
    show(dlr_hand, current)
    break if total[0] >= 17
    display_total(current, total)
  end
  declare_dealer_result(current, total)
end

def declare_dealer_result(current, total)
  if total[0] < 22
    display_total(current, total)
    prompt "Dealer will stay"
    pause(2)
  elsif busted?(total)
    declare_bust(current, total)
  end
end

def declare_bust(current, total)
  pause(2)
  prompt "Bust! #{current} drew #{total[0]}"
  pause(2)
end

def ready_for_next_round?
  player_input = nil
  loop do
    prompt ""
    prompt "Press ENTER or RETURN key to advance to the next round"
    player_input = gets.chomp
    break if !player_input.nil?
  end
end

def display_round_results(plyr_total, dlr_total, round, wins)
  display_end_of_round_score(plyr_total, dlr_total, round)
  prompt ""
  declare_round_winner(plyr_total, dlr_total, wins)
  pause(2)
end

def declare_round_winner(plyr_total, dlr_total, wins)
  winner = nil
  if plyr_total[0] > 21
    winner = "Dealer"
    update_round_wins(:dealer, wins)
  elsif dlr_total[0] > 21
    winner = "You"
    update_round_wins(:player, wins)
  elsif plyr_total[0] > dlr_total[0]
    winner = "You"
    update_round_wins(:player, wins)
  elsif dlr_total[0] > plyr_total[0]
    winner = "Dealer"
    update_round_wins(:dealer, wins)
  end
  winner ? prompt("#{winner} won this round!") : prompt("It's a tie!")
end

def display_end_of_round_score(plyr_total, dlr_total, round)
  prompt ""
  prompt "Final Score for Round #{round}:"
  pause(2)
  prompt "Player #{plyr_total[0]}, Dealer #{dlr_total[0]}"
  pause(2)
end

def update_round_wins(player, wins)
  wins[player] += 1
end

def won_three?(wins)
  wins[:player] == CHAMPION_WINS || wins[:dealer] == CHAMPION_WINS
end

def declare_game_winner(wins)
  prompt ""
  if wins[:player] == CHAMPION_WINS
    prompt "Congrats! You've won #{CHAMPION_WINS} rounds!"
  else
    prompt "Dealer has won #{CHAMPION_WINS} rounds!"
    prompt "Game over =("
  end
  pause(2)
  prompt ""
end

intro_message

loop do
  system 'clear'
  round = 1
  round_wins = {
    player: 0,
    dealer: 0
  }
  loop do
    player_hand = []
    dealer_hand = []
    current_player = "You"

    deck = initialize_deck
    deal_initial_cards(deck, player_hand, dealer_hand)

    player_total = [calculate_total(player_hand)]
    dealer_total = [calculate_total(dealer_hand)]

    update_dealt_cards(player_hand, dealer_hand, current_player)
    show_initial_cards(player_hand, dealer_hand, player_total)

    player_turn(deck, player_hand, dealer_hand, player_total, current_player)

    # Player Busts
    if busted?(player_total)
      display_round_results(player_total, dealer_total, round, round_wins)
      break if won_three?(round_wins)
      round += 1
      ready_for_next_round?
      next
    end

    current_player = "Dealer"
    update_dealt_cards(player_hand, dealer_hand, current_player)
    prompt ""

    dealer_turn(deck, dealer_hand, player_hand, current_player, dealer_total)

    # Dealer Busts
    if busted?(dealer_total)
      display_round_results(player_total, dealer_total, round, round_wins)
      break if won_three?(round_wins)
      round += 1
      ready_for_next_round?
      next
    end

    # Both Players 'Stay'
    update_dealt_cards(player_hand, dealer_hand, current_player)
    display_round_results(player_total, dealer_total, round, round_wins)
    break if won_three?(round_wins)
    round += 1
    ready_for_next_round?
    next
  end

  declare_game_winner(round_wins)
  prompt "Would you like to play again? 'Y' = Yes, 'N' = No"
  choice = gets.chomp
  break if choice.downcase.start_with?("n")
end

prompt "Thanks for playing Twenty One! Goodbye!"
