class ProjectForm
  include ActiveModel::Model

  attr_accessor :name, :start_date, :end_date, :order, :project_code, :group, :members
end
