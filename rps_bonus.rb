VALID_CHOICES = ["rock", "paper", "scissors", "lizard", "spock"]

WIN = {
  rock: { scissors: "smashes", lizard: "smashes" },
  paper: { rock: "covers", spock: "disproves" },
  scissors: { paper: "cuts", lizard: "decapitate" },
  lizard: { spock: "poisons", paper: "eats" },
  spock: { scissors: "smashes", rock: "vaporizes" }
}

CHAMPION = 3

def prompt(message)
  puts "==> #{message}"
end

def retreive_user_choice
  choice = ""

  loop do
    prompt("Choose one: r=rock, p=paper, sc=scissors, l=lizard OR sp=spock")
    choice = gets.chomp.downcase
    choice = translate(choice)
    break if VALID_CHOICES.include?(choice)
    prompt("Please enter 'r', 'p', 'sc', 'l' or 'sp'!")
  end
  choice
end

def translate(input)
  case input
  when "r" then "rock"
  when "p" then "paper"
  when "sc" then "scissors"
  when "l" then "lizard"
  when "sp" then "spock"
  end
end

def win?(player1, player2)
  WIN[player1.to_sym].keys.include?(player2.to_sym)
end

def game_over?(player, computer)
  player == CHAMPION || computer == CHAMPION
end

def display_winner(player)
  if player == CHAMPION
    prompt("Congrats Champ! You won 3 times.")
  else
    prompt("Game over! The Computer won 3 games")
  end
end

prompt("Welcome to Rock, Paper, Scissors, Lizard, Spock")
prompt("First player to win 3 games will be the Champ!")
round = 1
player_wins = 0
computer_wins = 0

loop do
  user_choice = retreive_user_choice
  computer_choice = VALID_CHOICES.sample

  user_cap = user_choice.capitalize
  computer_cap = computer_choice.capitalize

  user_action = WIN[user_choice.to_sym][computer_choice.to_sym]
  computer_action = WIN[computer_choice.to_sym][user_choice.to_sym]

  prompt("Round #{round}: #{user_cap} vs. #{computer_cap}")

  if win?(user_choice, computer_choice)
    player_wins += 1
    prompt("You win! #{user_cap} #{user_action} #{computer_cap}")
  elsif win?(computer_choice, user_choice)
    computer_wins += 1
    prompt("Computer Wins! #{computer_cap} #{computer_action} #{user_cap}")
  else
    prompt("It's a tie!")
  end

  if game_over?(player_wins, computer_wins)
    display_winner(player_wins)
    round = 1
    player_wins = 0
    computer_wins = 0
    prompt("Would you like to play again?")
    answer = gets.chomp
    break unless answer.downcase.start_with?("y")
  else
    round += 1
    prompt("Score: You = #{player_wins}, Computer = #{computer_wins}")
  end
end

prompt("Thanks for playing!")
