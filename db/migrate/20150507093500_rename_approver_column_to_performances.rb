class RenameApproverColumnToPerformances < ActiveRecord::Migration
  def change
    rename_column :performances, :approver, :approver_id
  end
end
