class Performance < ActiveRecord::Base
  belongs_to :user,      :class_name => "User",  :foreign_key => "user_id"
  belongs_to :approver,  :class_name => "User",  :foreign_key => "approver_id"
  belongs_to :project

  validates :start_time,  presence: true
  validates :end_time,    presence: true
  validates :content,     presence: true
  validates :project_id,  presence: true
  validates :user_id,     presence:true
  validates :approver_id, presence: true, if: :approve?

  validate  :end_time_check
  validate  :approver_is_admin?, if: :approve?

  def end_time_check
    if self.end_time <= self.start_time
      errors.add(:end_time, "日付を正しく入力してください．")
    end
  end

  def approver_is_admin?
    unless User.find(self.approver_id).admin?
      errors.add(:approver, "承認者は管理者のみです．")
    end
  end

  def approve?
    self.permission == true
  end
end
