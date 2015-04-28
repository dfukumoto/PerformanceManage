class PerformanceForm
  include ActiveModel::Model

  attr_accessor :start_date, :start_time, :end_date, :end_time, :permission, :content

  def performance_attributes
    {
        start_time: performance_start_datetime,
          end_time: performance_end_datetime,
        permission: @permission,
           content: @content
    }
  end

  def performance_start_datetime
    "#{@start_date} #{@start_time}"
  end

  def performance_end_datetime
    "#{@end_date} #{@end_time}"
  end

  def save
    binding.pry
    @performance = Performance.new(performance_attributes)
    if @performance.save
      true
    else
      false
    end
  end
end
