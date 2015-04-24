class CreatePerformances < ActiveRecord::Migration
  def change
    create_table :performances do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.text :content
      t.boolean :permission

      t.timestamps
    end
  end
end
