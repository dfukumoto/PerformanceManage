class Performance < ActiveRecord::Base
  belongs_to :user
  belongs_to :project

  validates :start_time,  presence: true
  validates :end_time,    presence: true
  validates :content,     presence: true
  validate  :end_time_check

  def self.create_date
    date_array = (Date.today.prev_month..Date.today).to_a.reverse!
    date_array.map!{|date| date.to_s }
  end

  def self.create_time
    time_range = Time.now.all_day
    time = time_range.first
    last = time_range.last
    return_array = []
    while time < last
      return_array << time
      time += 30.minutes
    end
    return_array.map!{|time| time.strftime("%H:%M").to_s}
  end

  def end_time_check
    if self.end_time >= self.start_time
      errors.add(:end_time, "日付を正しく入力してください．")
    end
  end
end
