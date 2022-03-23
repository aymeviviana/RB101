def prompt(message)
  puts "*** #{message}"
end

def input_valid?(input)
  input.gsub!(",", "")
  input.to_f > 0 && input.empty? == false
end

def retrieve_loan_amount
  loan = ""
  loop do
    prompt("Please enter your loan amount -- Omit $ signs and commas please!")
    loan = gets.chomp
    break if input_valid?(loan)
    prompt("Loan amount must be a positive, non-zero number. Try again!")
  end
  loan
end

def retrieve_apr
  apr = ""
  loop do
    prompt("Please enter your APR -- If 5% enter 5, if 3.75% enter 3.75")
    apr = gets.chomp
    break if input_valid?(apr)
    prompt("APR must be a positive, non-zero number. Try again!")
  end
  apr
end

def retrieve_loan_duration
  duration = ""
  loop do
    prompt("Please enter your loan duration in years.")
    duration = gets.chomp
    break if input_valid?(duration)
    prompt("Loan duration must be a positive, non-zero number. Try again!")
  end
  duration
end

def calc_monthly_rate(apr)
  apr.to_f / 100 / 12
end

def calc_payment(loan, interest, months)
  loan.to_f * (interest / (1 - (1 + interest)**(-months)))
end

loop do
  prompt("Welcome to the Mortgage Calculator!")
  loan_amount = retrieve_loan_amount
  apr_amount = retrieve_apr
  loan_duration_years = retrieve_loan_duration
  loan_duration_months = loan_duration_years.to_f * 12
  monthly_rate = calc_monthly_rate(apr_amount)
  monthly_payment = calc_payment(loan_amount, monthly_rate, loan_duration_months)

  puts "Your monthly interest rate is #{(monthly_rate * 100).round(2)}%"
  puts "Your loan duration is #{loan_duration_months.to_i} months"
  puts "Your monthly payment comes out to $#{monthly_payment.round(2)}"

  prompt("Would you like to run another calculation? (Y or N)")
  another_calculation = gets.chomp.downcase
  break if another_calculation.include?("n")
end

prompt("Thanks! Goodbye!")
