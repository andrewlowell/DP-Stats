require 'date'
require 'csv'
require 'descriptive_statistics'

six_inch_sandwiches = [
  "regular traditional",
  "regular philly bleu",
  "regular pizza",
  "regular hot pep",
  "regular mush pep",
  "regular cherry pep",
  "regular whiz",
  "regular cream"
]

nine_inch_sandwiches = [
  "large traditional",
  "large philly bleu",
  "large pizza",
  "large hot pep",
  "large mush pep",
  "large cherry pep",
  "large whiz",
  "large cream"
]

stats = {
  :mon => {},
  :tue => {},
  :wed => {},
  :thu => {},
  :fri => {},
  :sat => {},
  :sun => {}
}
# *** Do some work on each file in the data directory
Dir.glob('./data/*.csv') do |file|
  temp_csv = CSV.new(File.read(file), :headers => true, :header_converters => :symbol, :converters => :all)
  csv = temp_csv.to_a.map { |row| row.to_hash }

  # *** Do some work on each individual sale
  csv.each do |sale|
    date = Date.strptime(sale[:transaction_date].split(' ').first, "%m/%d/%Y")
    case Date::ABBR_DAYNAMES[date.wday]
    when "Mon"
      sale[:day_of_week] = :mon
    when "Tue"
      sale[:day_of_week] = :tue
    when "Wed"
      sale[:day_of_week] = :wed
    when "Thu"
      sale[:day_of_week] = :thu
    when "Fri"
      sale[:day_of_week] = :fri
    when "Sat"
      sale[:day_of_week] = :sat
    when "Sun"
      sale[:day_of_week] = :sun
    end
  end

  # *** Put each sale in the right day of the week in the stats hash
  csv.each do |sale|

    if six_inch_sandwiches.include? sale[:product]
      if stats[sale[:day_of_week].to_sym].has_key? sale[:transaction_date].split(' ').first
        stats[sale[:day_of_week]][sale[:transaction_date].split(' ').first] = stats[sale[:day_of_week]][sale[:transaction_date].split(' ').first] + 6
      else
        stats[sale[:day_of_week]][sale[:transaction_date].split(' ').first] = 6
      end

    elsif nine_inch_sandwiches.include? sale[:product]

      if stats[sale[:day_of_week]].has_key? sale[:transaction_date].split(' ').first
        stats[sale[:day_of_week]][sale[:transaction_date].split(' ').first] = stats[sale[:day_of_week]][sale[:transaction_date].split(' ').first] + 9
      else
        stats[sale[:day_of_week]][sale[:transaction_date].split(' ').first] = 9
      end
    end
  end

  puts "Monday -- mean: #{'%.2f' % (stats[:mon].mean / 18)} (bags) -- standard deviation: #{'%.2f' % (stats[:mon].standard_deviation / 18)} (bags)"
  puts "Tuesday -- mean: #{'%.2f' % (stats[:tue].mean / 18)} (bags) -- standard deviation: #{'%.2f' % (stats[:tue].standard_deviation / 18)} (bags)"
  puts "Wednesday -- mean: #{'%.2f' % (stats[:wed].mean / 18)} (bags) -- standard deviation: #{'%.2f' % (stats[:wed].standard_deviation / 18)} (bags)"
  puts "Thursday -- mean: #{'%.2f' % (stats[:thu].mean / 18)} (bags) -- standard deviation: #{'%.2f' % (stats[:thu].standard_deviation / 18)} (bags)"
  puts "Friday -- mean: #{'%.2f' % (stats[:fri].mean / 18)} (bags) -- standard deviation: #{'%.2f' % (stats[:fri].standard_deviation / 18)} (bags)"
  puts "Saturday -- mean: #{'%.2f' % (stats[:sat].mean / 18)} (bags) -- standard deviation: #{'%.2f' % (stats[:sat].standard_deviation / 18)} (bags)"

end
