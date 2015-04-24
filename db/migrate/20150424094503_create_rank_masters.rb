class CreateRankMasters < ActiveRecord::Migration
  def change
    create_table :rank_masters do |t|
      t.string :rank
      t.integer :cost
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
