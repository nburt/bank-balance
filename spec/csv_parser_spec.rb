require './lib/csv_parser'

describe CsvParser do
  describe "#parse" do
    it 'can parse csv into an array of arrays' do
      csv = File.read('./spec/support/test_csv.csv')
      expect(CsvParser.parse(csv)).to eq [
                                           ["2014-04-06", "Check #1077", nil, "$60.00"]
                                         ]
    end
  end
end