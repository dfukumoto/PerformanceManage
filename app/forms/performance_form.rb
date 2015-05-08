class PerformanceForm
  include ActiveModel::Model

  attr_accessor :start_date, :start_time, :end_date, :end_time, :content, :user_id, :project_id

  def assign_performance_attributs(performance)
    tap do |instance|
      instance.start_date = performance.start_time.strftime("%Y/%m/%d")
      instance.start_time = performance.start_time.strftime("%H:%M")
      instance.end_date   = performance.end_time.strftime("%Y/%m/%d")
      instance.end_time   = performance.end_time.strftime("%H:%M")
      instance.content    = performance.content
      instance.user_id    = performance.user_id
      instance.project_id = performance.project_id
    end
  end

  def performance_attributes
    {}.tap do |hash|
      hash.store(:start_time, performance_start_datetime)
      hash.store(:end_time, performance_end_datetime)
      hash.store(:content, @content)
      hash.store(:user_id, @user_id)
      hash.store(:project_id, @project_id)
    end
  end

  def performance_start_datetime
    "#{@start_date} #{@start_time}"
  end

  def performance_end_datetime
    "#{@end_date} #{@end_time}"
  end

  def save
    @performance = Performance.new(performance_attributes)
    @performance.save
  end
end
