board = [["_", "_", "_"], ["_", "_", "_"], ["_", "_", "_"]]
available_squares = [[0, 0], [0, 1], [0, 2], [1, 0], [1, 1], [1, 2], [2, 0], [2, 1], [2, 2]]

def prompt(message)
  puts "*** #{message}"
end

def user_select_square(player, board, available_squares)
  loop do
    prompt("Please select an available row")
    row = gets.chomp.to_i - 1

    prompt("Please select an available column")
    col = gets.chomp.to_i - 1

    if square_available?(row, col, board)
      update_board!(player, row, col, board)
      update_available_squares!(row, col, available_squares)
      break
    else
      prompt("Square not available, please choose again!")
    end
  end
end

def print_board(board)
  board.each { |row| p row }
end

def square_available?(row, col, board)
  board[row][col] == "_"
end

def update_board!(player, row, col, board)
  board[row][col] = player
end

def update_available_squares!(row, col, available_squares)
  available_squares.delete([row, col])
end

def winner?(board, player)
  wins = [row_win?(board, player), col_win?(board, player), diag_win?(board, player)]
  wins.any?
end

def row_win?(board, player)
  result = board.map { |row| row == [player, player, player] }
  result.include?(true)
end

def col_win?(board, player)
  col1 = []
  col2 = []
  col3 = []

  board.each do |row|
    col1 << row[0]
    col2 << row[1]
    col3 << row[2]
  end
  [col1, col2, col3].any? { |col| col == [player, player, player] }
end

def diag_win?(board, player)
  diag1 = [board[0][0], board[1][1], board[2][2]]
  diag2 = [board[0][2], board[1][1], board[2][0]]

  [diag1, diag2].any? { |diag| diag == [player, player, player] }
end

def declare_winner(player, board)
  prompt("#{player}'s won! ***")
  prompt("FINAL BOARD: ***")
  print_board(board)
end

def declare_tie(board)
  prompt("It's a tie! ***")
  prompt("FINAL BOARD: ***")
  print_board(board)
end

def reset_game!(board, available_squares)
  board.map! { |_| ["_", "_", "_"] }
  available_squares.clear
  available_squares << [[0, 0], [0, 1], [0, 2], [1, 0], [1, 1], [1, 2], [2, 0], [2, 1], [2, 2]]
  available_squares.flatten!(1)
end

############ GAME START ############
prompt("Welcome to Tic Tac Toe!")

prompt("Here's the starting board:")
print_board(board)

prompt("You'll be X's and I'll be O's")

loop do
  loop do
    player = "X"
    user_select_square(player, board, available_squares)
    print_board(board)

    if winner?(board, player)
      declare_winner(player, board)
      break
    elsif available_squares.empty?
      declare_tie(board)
      break
    end

    player = "O"
    comp_row, comp_col = available_squares.sample

    update_board!(player, comp_row, comp_col, board)
    update_available_squares!(comp_row, comp_col, available_squares)

    prompt("Computer selected row #{comp_row + 1}, column #{comp_col + 1}")
    print_board(board)

    if winner?(board, player)
      declare_winner(player, board)
      break
    elsif available_squares.empty?
      declare_tie(board)
      break
    end
  end

  reset_game!(board, available_squares)
  prompt("Would you like to play again? Y/N")
  user_response = gets.chomp.downcase
  break if user_response.start_with?("n")
end

prompt("Thanks for playing!")
