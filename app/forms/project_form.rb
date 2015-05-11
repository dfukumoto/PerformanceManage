class ProjectForm
  include ActiveModel::Model

  attr_accessor :name, :start_date, :end_date, :order, :project_code, :group_id, :members

  def project_attributes
    {}.tap do |hash|
      hash.store(:name,       @name)
      hash.store(:start_date, @start_date)
      hash.store(:end_date,   @end_date)
      hash.store(:order,      @order)
      hash.store(:project_code,@project_code)
      hash.store(:group_id,      @group_id)
    end
  end

end
