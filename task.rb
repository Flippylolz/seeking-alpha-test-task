# # Write a parser for FB hours format.
# # Display working hours in folded/unfolded way.
# # Folded meaning that if the opening-closing hours are the same,
# # then you write Mon-Thu same hour instead of writing opening hours for each day
schedule = {
  "mon_1_open":  "09:00",
  "mon_1_close": "13:00",
  "tue_1_open":  "09:00",
  "tue_1_close": "13:00",
  "wed_1_open":  "16:00",
  "wed_1_close": "20:00",
  "thu_1_open":  "09:00",
  "thu_1_close": "13:00",
  "fri_1_open":  "09:00",
  "fri_1_close": "13:00",
  "sat_1_open":  "09:00",
  "sat_1_close": "14:00",
  "mon_2_open":  "16:00",
  "mon_2_close": "20:00",
  "tue_2_open":  "16:00",
  "tue_2_close": "20:00"
}

class FbTimeParser
  DAYS_OF_WEEK = %w[Mon Tue Wed Thu Fri Sat Sun]
  CLOSED = "Closed"
  
  class << self
    def call(...)
      new(...).call
    end
  end

  def initialize(schedule)
    @schedule = schedule
  end

  def parse_hours(folded: false)
    hours = folded ? [] : Array.new(7, [])

    DAYS_OF_WEEK.each_with_index do |day_name, day_index|
      day_hours = get_day_hours(day_name, day_index, folded)
      hours[day_index] = day_hours unless folded
      puts format_hours(day_name, day_hours)
    end

    return hours if folded
  end

  private

  def get_day_hours(day_name, day_index, folded)
    start_key = "#{day_name.downcase}_1_open".to_sym
    end_key = "#{day_name.downcase}_1_close".to_sym
    second_start_key = "#{day_name.downcase}_2_open".to_sym
    second_end_key = "#{day_name.downcase}_2_close".to_sym

    if @schedule.key?(start_key) && @schedule.key?(end_key)
      start_time = Time.parse(@schedule[start_key])
      end_time = Time.parse(@schedule[end_key])
      if @schedule.key?(second_start_key) && @schedule.key?(second_end_key)
        second_start_time = Time.parse(@schedule[second_start_key])
        second_end_time = Time.parse(@schedule[second_end_key])
        return [[start_time, end_time], [second_start_time, second_end_time]]
      else
        return [[start_time, end_time]]
      end
    else
      return CLOSED
    end
  end

  def format_hours(day_name, day_hours)
    if day_hours == CLOSED
      "#{day_name}: #{CLOSED}"
    else
      hours_str = day_hours.map { |range| format_range(range) }.join(", ")
      "#{day_name}: #{hours_str}"
    end
  end

  def format_range(range)
    start_time, end_time = range
    start_str = start_time.strftime("%H:%M")
    end_str = end_time.strftime("%H:%M")
    "#{start_str}-#{end_str}"
  end
end

result = FbTimeParser.(schedule)

p result
