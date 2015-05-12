class RemoveGroupIdToProjectGroups < ActiveRecord::Migration
  def change
    remove_column :project_groups, :group_id, :string
  end
end
