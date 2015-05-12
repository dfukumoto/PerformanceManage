class RenameGroupColumnToProjects < ActiveRecord::Migration
  def change
    rename_column :projects, :group, :group_id
  end
end
