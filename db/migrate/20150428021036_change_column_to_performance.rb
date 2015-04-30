class ChangeColumnToPerformance < ActiveRecord::Migration
  def change
    change_column :performances, :permission, :boolean, default: false
  end
end
