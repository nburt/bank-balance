require File.dirname(__FILE__) + "/../lib/account_report_generator"
require File.dirname(__FILE__) + "/../lib/csv_parser"

datafiles = Dir.glob("../data/*.csv").map do |file|
  File.read(file)
end

cc_statements = []
checking_statements = []

datafiles.each do |file|
  parsed_file = CsvParser.parse(file)
  parsed_file.each do |statement|
    if statement.length == 3
      cc_statements << statement
    elsif statement.length == 4
      checking_statements << statement
    end
  end
end

generator = AccountReportGenerator.new(checking_statements, cc_statements)
p generator.monthly


