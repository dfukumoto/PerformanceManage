class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.date :start_date
      t.date :end_date
      t.integer :group
      t.string :order
      t.string :project_code

      t.timestamps
    end
  end
end
