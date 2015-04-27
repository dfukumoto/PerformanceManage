class Project < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :performances
  belongs_to :project_group
  has_many :users, through: :project_members
end
