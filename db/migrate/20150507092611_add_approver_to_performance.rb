class AddApproverToPerformance < ActiveRecord::Migration
  def change
    add_column :performances, :approver, :integer
  end
end
