# PSEUDO-CODE
=begin
Ask user for loan amount (no commas or dollar signs please)
Validate loan amount (only integers and floats allowed, 0 not allowed)

Ask user for APR (if 5% enter 5, if 3.75% enter 3.75)
Validate APR (only integers and floats allowed, 0 not allowed)

Ask user for loan duration in years
Validate loan duration (only integers and floats allowed, 0 not allowed)

calculate loan duration in months and store result in a variable

call method that returns monthly interest rate

call method that returns monthly payment amount
=end

# Method Definitions
# ==================
def prompt(message)
  puts "*** #{message}"
end

def input_valid?(input)
  input.gsub!(",", "")
  input.to_f > 0 && input.empty? == false
end

def calc_monthly_rate(apr)
  apr.to_f / 100 / 12
end

def calc_payment(loan, interest, months)
  loan.to_f * (interest / (1 - (1 + interest)**(-months)))
end

# Retrieve and validate loan amount
# =================================

prompt("Welcome to the Mortgage Calculator!")
loan_amount = ""

loop do
  prompt("Please enter your loan amount -- Omit $ signs and commas please!")

  loan_amount = gets.chomp

  break if input_valid?(loan_amount)

  prompt("Loan amount must be a positive, non-zero number. Please try again!")
end

# Retrieve and validate APR
# =========================
apr_amount = ""

loop do
  prompt("Please enter your APR -- If 5% enter 5, if 3.75% enter 3.75")

  apr_amount = gets.chomp

  break if input_valid?(apr_amount)

  prompt("APR must be a positive, non-zero number. Please try again!")
end

# Retrieve and validate loan duration
# ===================================
loan_duration_years = ""

loop do
  prompt("Please enter your loan duration in years.")
  loan_duration_years = gets.chomp

  break if input_valid?(loan_duration_years)

  prompt("Loan duration must be a positive, non-zero number. Please try again!")
end

# Calculate and store loan duration, interest rate & payment values
# =================================================================
loan_duration_months = loan_duration_years.to_f * 12

monthly_rate = calc_monthly_rate(apr_amount)

monthly_payment = calc_payment(loan_amount, monthly_rate, loan_duration_months)

# Output loan duration, interest & payment values to the user
# ===========================================================
puts "Your monthly interest rate is #{(monthly_rate * 100).round(2)}%"
puts "Your loan duration is #{loan_duration_months.to_i} months"
puts "Your monthly payment comes out to $#{monthly_payment.round(2)}"
