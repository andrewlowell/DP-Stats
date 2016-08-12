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

# *** Initialize the data structure to hold all the sales data for each day of the week.
stats = {
  :mon => {},
  :tue => {},
  :wed => {},
  :thu => {},
  :fri => {},
  :sat => {},
  :sun => {}
}
# *** Do some work for each file in the /data directory.
Dir.glob('./data/*.csv') do |file|
  temp_csv = CSV.new(File.read(file), :headers => true, :header_converters => :symbol, :converters => :all)
  csv = temp_csv.to_a.map { |row| row.to_hash }

  # *** Each sale includes a date, but not a day of the week; this code adds a key:value pair with the correct day of the week.
  csv.each do |sale|
    # *** The following line takes an American date like 5/6/2004 and turns it into a ruby Date object
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

  # *** Iterate through each sale to start aggregating data.
  csv.each do |sale|

    # *** If the sale was of a 6-inch cheesesteak, then add 6 inches to the amount of bread used that day, or if this is the first sale of the day, add a key:value pair for that day.
    if six_inch_sandwiches.include? sale[:product]
      if stats[sale[:day_of_week].to_sym].has_key? sale[:transaction_date].split(' ').first
        stats[sale[:day_of_week]][sale[:transaction_date].split(' ').first] = stats[sale[:day_of_week]][sale[:transaction_date].split(' ').first] + 6
      else
        stats[sale[:day_of_week]][sale[:transaction_date].split(' ').first] = 6
      end

    # *** Same as above for 9-inchers.
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
