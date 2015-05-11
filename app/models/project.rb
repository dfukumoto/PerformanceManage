class Project < ActiveRecord::Base
  has_many :performances
  belongs_to :project_group
  has_one :project_group, :class_name => "ProjectGroup",  :primary_key => "group_id", :foreign_key => "id"
  has_many :project_members
  has_many :users, through: :project_members
  has_many :partner_costs

  validates :name,        presence: true
  validates :start_date,  presence: true
  validates :end_date,    presence: true
  validates :order,       presence: true
  validates :project_code,presence: true
  validates :group_id,    presence: true
end
