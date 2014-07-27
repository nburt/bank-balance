require './lib/account_report_generator'

describe AccountReportGenerator do
  describe "#monthly" do
    it 'calculates the monthly balance of checking and credit card accounts' do
      credit_card_statement = [
        ["2014-02-04", "Some product", "$10.00"],
        ["2014-02-04", "Other product", "$5.00"],
        ["2014-02-05", "Payment Thank You", "$-100.00"]
      ]

      checking_statement = [
        ["2014-02-03", "Check #34", "", "$20.00"],
        ["2014-02-04", "Deposit ATM", "$100.00", ""],
        ["2014-02-05", "Payment CC", "", "$100 .00"]
      ]

      generator = AccountReportGenerator.new(checking_statement, credit_card_statement)

      expect(generator.monthly).to eq [
                                        {year: 2014, month: "February", balance: "$65.00"}
                                      ]
    end
  end
end