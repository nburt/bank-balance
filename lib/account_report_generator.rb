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
    analyzed_checking_statement = analyze_checking_statement
    deposits = analyzed_checking_statement.deposits
    non_cc_withdrawals = analyzed_checking_statement.non_cc_withdrawals
    cc_purchases = calculate_cc_purchases
    balance = deposits - (non_cc_withdrawals + cc_purchases)
    date = Date.parse(@checking_statement.first[0])
    [
      {
        year: date.year,
        month: MONTHS[date.month],
        balance: "$#{"%.2f" % balance}"
      }
    ]
  end

  private

  def analyze_checking_statement
    deposits = 0
    non_cc_withdrawals = 0

    @checking_statement.each do |transaction|
      deposit = transaction[2].gsub("$", "").to_i
      deposits += deposit

      if transaction[1] != "Payment CC"
        non_cc_withdrawal = transaction[3].gsub("$", "").to_i
        non_cc_withdrawals += non_cc_withdrawal
      end
    end

    analyzed_checking_statement = Struct.new(:deposits, :non_cc_withdrawals)
    analyzed_checking_statement.new(deposits, non_cc_withdrawals)
  end

  def calculate_cc_purchases
    cc_purchases = 0
    @credit_card_statement.each do |transaction|
      transaction_amount = transaction[2].gsub("$", "").to_i
      if transaction_amount > 0
        cc_purchases += transaction_amount
      end
    end
    cc_purchases
  end

end