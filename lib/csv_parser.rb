require 'csv'

class CsvParser

  def self.parse(csv)
    parsed_csv = CSV.parse(csv)
    parsed_csv.shift
    parsed_csv
  end

end