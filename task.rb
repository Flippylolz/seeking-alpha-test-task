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
  class << self
    def call(...)
      new(...).call
    end
  end

  def initialize(schedule)
    @schedule = schedule
  end

  def call
    splitted_keys = split_keys_by_day
    grouped_by_day = group_by_day(splitted_keys)
    time_periods = time_periods(grouped_by_day)

    grouped_data = group_days_and_time(time_periods)

    format_response(grouped_data)
  end

  private

  def split_keys_by_day
    @schedule.map { |k, v| [k.to_s.split("_"), v] }.to_h
  end

  def group_by_day(splitted_keys)
    splitted_keys.group_by { |k, _ | k.first }
  end

  def time_periods(grouped_by_day)
    grouped_by_day.each do |_, value|
      value.each do |a|
        a.shift
      end
    end.each_value(&:flatten!)
  end

  def group_days_and_time(time_periods)
    time_periods.group_by(&:last)
                .each { |_, v| v.map!(&:first) }
                .invert
  end

  def format_response(data)
    data.transform_keys! { |key| key.map(&:capitalize).join('-') }
    data.transform_values! { |value| value.each_slice(2).map { |time| "#{time.first} - #{time.last}" }.join(', ') }
  end
end

result = FbTimeParser.(schedule)

p result
