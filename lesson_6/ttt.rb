WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # cols
                [[1, 5, 9], [3, 5, 7]] # diagonals
INITIAL_MARKER = " "
PLAYER_MARKER = "X"
COMPUTER_MARKER = "O"

def prompt(msg)
  puts "=> #{msg}"
end

def user_select_player(first)
  loop do
    prompt "Who should go first? 'P' = Player, 'C' = Computer"
    user_response = gets.chomp.downcase
    first << user_response if valid_selection?(user_response)
    break if valid_selection?(user_response)
    prompt "Please enter 'P' or 'C'"
  end
end

def valid_selection?(user_rsp)
  user_rsp == "p" || user_rsp == "c"
end

def initialize_board
  new_board = {}
  (1..9).each { |num| new_board[num] = INITIAL_MARKER }
  new_board
end

def start_game(brd, scr, rnd, current)
  loop do
    display_board(brd)
    p_score = scr['player']
    c_score = scr['computer']
    prompt "ROUND #{rnd}: Player #{p_score}, Computer #{c_score}"
    select_square!(brd, current)
    current[0] = alternate_player!(current)
    break if someone_won?(brd) || board_full?(brd)
  end
end

# rubocop: disable Metrics/AbcSize
def display_board(brd)
  system 'clear'
  puts "You're an #{PLAYER_MARKER}. Computer is an #{COMPUTER_MARKER}"
  puts ""
  puts "     |     |"
  puts "  #{brd[1]}  |  #{brd[2]}  |  #{brd[3]}  "
  puts "     |     |"
  puts "_____+_____+_____"
  puts "     |     |"
  puts "  #{brd[4]}  |  #{brd[5]}  |  #{brd[6]}  "
  puts "     |     |"
  puts "_____+_____+_____"
  puts "     |     |"
  puts "  #{brd[7]}  |  #{brd[8]}  |  #{brd[9]}  "
  puts "     |     |"
  puts ""
end
# rubocop: enable Metrics/AbcSize

def empty_squares(brd)
  brd.keys.select { |num| brd[num] == INITIAL_MARKER }
end

def select_square!(brd, current)
  current == "p" ? player_select_square!(brd) : computer_select_square!(brd)
end

def alternate_player!(current)
  letter = if current == "p"
             "c"
           else
             "p"
           end
  current[0] = letter
end

def player_select_square!(brd)
  square = ""

  loop do
    prompt("Choose a square (#{joinor(empty_squares(brd))}):")
    square = gets.chomp.to_i
    break if empty_squares(brd).include?(square)
    prompt("Sorry, that's not a valid choice")
  end
  brd[square] = PLAYER_MARKER
end

def random_sqr!(brd)
  square = empty_squares(brd).sample
  brd[square] = COMPUTER_MARKER
end

# rubocop: disable Metrics/CyclomaticComplexity
def computer_select_square!(brd)
  # OFFENSE
  WINNING_LINES.each do |line|
    markers = brd.values_at(*line)
    if markers.count(COMPUTER_MARKER) == 2 && markers.count(INITIAL_MARKER) == 1
      select_empty_square!(brd, line, markers)
      return nil
    end
  end
  # DEFENSE
  WINNING_LINES.each do |line|
    markers = brd.values_at(*line)
    if markers.count(PLAYER_MARKER) == 2 && markers.count(INITIAL_MARKER) == 1
      select_empty_square!(brd, line, markers)
      return nil
    end
  end
  empty_squares(brd).include?(5) ? brd[5] = COMPUTER_MARKER : random_sqr!(brd)
end
# rubocop: enable Metrics/CyclomaticComplexity

def select_empty_square!(brd, line, markers)
  empty_square = line[markers.index(INITIAL_MARKER)]
  brd[empty_square] = COMPUTER_MARKER
end

def board_full?(brd)
  empty_squares(brd).empty?
end

def someone_won?(brd)
  !!detect_winner(brd)
end

def detect_winner(brd)
  WINNING_LINES.each do |line|
    if brd.values_at(*line).count(PLAYER_MARKER) == 3
      return "Player"
    elsif brd.values_at(*line).count(COMPUTER_MARKER) == 3
      return "Computer"
    end
  end
  nil
end

# rubocop: disable Metrics/AbcSize
def joinor(arr, delim=', ', word='or')
  if arr.size == 1
    arr[0].to_s
  elsif arr.size == 2
    arr[0].to_s + " #{word} " + arr[1].to_s
  else
    result = arr.map do |num|
      num == arr[-1] ? word + ' ' + num.to_s : num.to_s + delim
    end
    result.join
  end
end
# rubocop: enable Metrics/AbcSize

def display_result(brd, scr)
  if someone_won?(brd)
    winner = detect_winner(brd)
    prompt "#{winner} won!"
    update_score(scr, winner)
  else
    prompt "It's a tie!"
  end
end

def update_score(scr, winner)
  scr[winner.downcase] += 1
end

def five_wins?(scr)
  scr["player"] == 5 || scr["computer"] == 5 ? true : false
end

def declare_winner(scr)
  prompt "#{scr.key(5).capitalize} won 5 games!"
end

loop do
  score = {
    "player" => 0,
    "computer" => 0
  }
  round = 1
  first = ""
  user_select_player(first)

  loop do
    board = initialize_board
    current_player = first.dup
    start_game(board, score, round, current_player)
    display_board(board)
    display_result(board, score)
    sleep 2
    five_wins?(score) ? declare_winner(score) : round += 1
    break if five_wins?(score)
  end
  prompt "Play again? (y or n)"
  answer = gets.chomp
  break unless answer.downcase.start_with?("y")
end

prompt "Thanks for playing Tic Tac Toe!"
