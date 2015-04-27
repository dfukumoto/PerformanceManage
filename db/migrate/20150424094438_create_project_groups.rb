class CreateProjectGroups < ActiveRecord::Migration
  def change
    create_table :project_groups do |t|
      t.integer :group_id
      t.string :group_name

      t.timestamps
    end
  end
end
