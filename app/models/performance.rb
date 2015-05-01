class Performance < ActiveRecord::Base
  belongs_to :user
  belongs_to :project

  validates :start_time,  presence: true
  validates :end_time,    presence: true
  validates :content,     presence: true
  validates :project_id,  presence: true
  validates :user_id,     presence:true

  validate  :end_time_check

  def end_time_check
    if self.end_time <= self.start_time
      errors.add(:end_time, "日付を正しく入力してください．")
    end
  end
end
