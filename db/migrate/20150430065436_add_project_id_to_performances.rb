class AddProjectIdToPerformances < ActiveRecord::Migration
  def change
    add_column :performances, :project_id, :integer
  end
end
