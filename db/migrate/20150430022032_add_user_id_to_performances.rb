class AddUserIdToPerformances < ActiveRecord::Migration
  def change
    add_column :performances, :user_id, :integer
  end
end
