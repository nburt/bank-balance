class AccountReportGenerator
  MONTHS = {
    1 => "January",
    2 => "February",
    3 => "March",
    4 => "April",
    5 => "May",
    6 => "June",
    7 => "July",
    8 => "August",
    9 => "September",
    10 => "October",
    11 => "November",
    12 => "December"
  }

  def initialize(checking_statement, credit_card_statement)
    @checking_statement = checking_statement
    @credit_card_statement = credit_card_statement
  end

  def monthly
    months_years = @checking_statement.map do |transaction|
      date = Date.parse(transaction[0])
      {
        year: date.year,
        month: date.month
      }
    end

    calculate_monthly_balances(months_years)
  end

  private

  def calculate_monthly_balances(months_years)
    months_years.uniq.map do |statement|
      analyzed_checking_statement = analyze_checking_statement(statement[:year], statement[:month])
      deposits = analyzed_checking_statement.deposits
      non_cc_withdrawals = analyzed_checking_statement.non_cc_withdrawals
      cc_purchases = calculate_cc_purchases(statement[:year], statement[:month])
      balance = deposits - (non_cc_withdrawals + cc_purchases)
      {
        year: statement[:year],
        month: MONTHS[statement[:month]],
        balance: "$#{"%.2f" % balance}"
      }
    end
  end

  def analyze_checking_statement(year, month)
    deposits = 0
    non_cc_withdrawals = 0

    monthly_statement = get_monthly_statement(year, month, @checking_statement)

    monthly_statement.each do |transaction|
      if !transaction[2].nil?
        deposit = transaction[2].gsub("$", "").gsub(",", "").to_f
        deposits += deposit
      end

      if transaction[1] != "Payment CC" && !transaction[3].nil?
        non_cc_withdrawal = transaction[3].gsub("$", "").gsub(",", "").to_f
        non_cc_withdrawals += non_cc_withdrawal
      end
    end

    analyzed_checking_statement = Struct.new(:deposits, :non_cc_withdrawals)
    analyzed_checking_statement.new(deposits, non_cc_withdrawals)
  end

  def calculate_cc_purchases(year, month)
    cc_purchases = 0

    monthly_statement = get_monthly_statement(year, month, @credit_card_statement)

    monthly_statement.each do |transaction|
      transaction_amount = transaction[2].gsub("$", "").gsub(",", "").to_f
      if transaction_amount > 0
        cc_purchases += transaction_amount
      end
    end
    cc_purchases
  end

  def get_monthly_statement(year, month, statement)
    statement.select do |transaction|
      transaction_date = Date.parse(transaction[0])
      transaction_date.year == year && transaction_date.month == month
    end
  end

end