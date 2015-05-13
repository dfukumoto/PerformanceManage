class PerformanceForm
  include ActiveModel::Model

  attr_accessor :start_time, :end_time, :content, :user_id, :project_id

  def assign_performance_attributs(performance)
    tap do |instance|
      instance.start_time = performance.start_time
      instance.end_time   = performance.end_time
      instance.content    = performance.content
      instance.user_id    = performance.user_id
      instance.project_id = performance.project_id
    end
  end

  def performance_attributes
    {}.tap do |hash|
      hash.store(:start_time, @start_time)
      hash.store(:end_time, @end_time)
      hash.store(:content, @content)
      hash.store(:user_id, @user_id)
      hash.store(:project_id, @project_id)
    end
  end

  def generate_datetime(instance)
    (self.send(instance) || DateTime.now).strftime("%Y-%m-%dT%H:%M")
  end

  def save
    @performance = Performance.new(performance_attributes)
    @performance.save
  end
end
