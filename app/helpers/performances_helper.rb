module PerformancesHelper
  def create_date
    date_array = (Date.today.prev_month..Date.today).to_a.reverse!
    date_array.map!{|date| date.to_s }
  end

  def create_time
    time = Time.now.beginning_of_day
    last = Time.now.end_of_day
    return_array = []
    while time < last
      return_array << time
      time += 30.minutes
    end
    return_array.map!{|time| time.strftime("%H:%M").to_s}
  end
end
