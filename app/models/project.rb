class Project < ActiveRecord::Base
  has_many :performances
  belongs_to :project_group
  has_many :project_members
  has_many :users, through: :project_members
  has_many :partner_costs
end
