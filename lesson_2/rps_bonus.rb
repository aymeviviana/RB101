WINNING_MOVES = {
  rock: { scissors: "smashes", lizard: "smashes" },
  paper: { rock: "covers", spock: "disproves" },
  scissors: { paper: "cuts", lizard: "decapitate" },
  lizard: { spock: "poisons", paper: "eats" },
  spock: { scissors: "smashes", rock: "vaporizes" }
}

CHAMPIONSHIP_WINS = 3

def prompt(message)
  puts "==> #{message}"
end

def retreive_user_choice
  choice = ""

  loop do
    prompt("Choose one: r=rock, p=paper, sc=scissors, l=lizard OR sp=spock")
    choice = gets.chomp.downcase
    choice = translate(choice)
    break if WINNING_MOVES.include?(choice.to_sym)
    prompt("Please enter 'r', 'p', 'sc', 'l' or 'sp'!")
  end
  choice
end

def translate(choice)
  case choice
  when "r" then "rock"
  when "p" then "paper"
  when "sc" then "scissors"
  when "l" then "lizard"
  when "sp" then "spock"
  else "error"
  end
end

def display_result(user_choice, computer_choice, score_board)
  action = retrieve_winning_action(user_choice, computer_choice)

  if win?(user_choice, computer_choice)
    update_score(:user, score_board)
    prompt("You Win! #{user_choice} #{action} #{computer_choice}")
  elsif win?(computer_choice, user_choice)
    update_score(:computer, score_board)
    prompt("Computer Wins! #{computer_choice} #{action} #{user_choice}")
  else
    prompt("It's a tie!")
  end
end

def retrieve_winning_action(user_choice, computer_choice)
  user_action = WINNING_MOVES[user_choice.to_sym][computer_choice.to_sym]
  computer_action = WINNING_MOVES[computer_choice.to_sym][user_choice.to_sym]

  user_action.nil? ? computer_action : user_action
end

def win?(player1, player2)
  WINNING_MOVES[player1.to_sym].keys.include?(player2.to_sym)
end

def update_score(player, board)
  board[player] += 1
end

def display_score(board)
  prompt("Score: You = #{board[:user]}, Computer = #{board[:computer]}")
end

def game_over?(board)
  board[:user] == CHAMPIONSHIP_WINS || board[:computer] == CHAMPIONSHIP_WINS
end

def display_champion(score_board)
  if score_board[:user] == CHAMPIONSHIP_WINS
    prompt("Congrats Champ! You won 3 times.")
  else
    prompt("Game over! The Computer won 3 games")
  end
end

def reset(score_board)
  score_board[:user] = 0
  score_board[:computer] = 0
end

prompt("Welcome to Rock, Paper, Scissors, Lizard, Spock")
prompt("First player to win 3 games will be the Champ!")
round = 1
score_board = {
  user: 0,
  computer: 0
}

loop do
  user_choice = retreive_user_choice
  computer_choice = WINNING_MOVES.keys.sample.to_sym

  prompt("Round #{round}: #{user_choice.upcase} vs. #{computer_choice.upcase}")

  display_result(user_choice, computer_choice, score_board)

  if game_over?(score_board)
    display_champion(score_board)
    reset(score_board)
    prompt("Would you like to play again?")
    answer = gets.chomp
    break unless answer.downcase.start_with?("y")
  else
    round += 1
    display_score(score_board)
  end
end

prompt("Thanks for playing!")
