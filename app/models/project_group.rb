class ProjectGroup < ActiveRecord::Base
  has_many :projects, class_name: "Project", foreign_key: "group_id"
  belongs_to :project
end
