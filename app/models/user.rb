class User < ActiveRecord::Base
  has_many :projects
  has_many :performances
  has_many :projects, through: :project_members
  has_many :rank_histories
  has_many :partner_costs
end
