class RenameGroupNameColumnToProjectgroups < ActiveRecord::Migration
  def change
    rename_column :project_groups, :group_name, :name
  end
end
