class Project < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :performances
  belongs_to :project_group
  has_many :project_members
  has_many :users, through: :project_members
  has_many :partner_costs
  has_many :users, through: :partner_costs
end
