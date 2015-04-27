class CreateRankHistories < ActiveRecord::Migration
  def change
    create_table :rank_histories do |t|
      t.integer :user_id
      t.date :start_time
      t.date :end_time
      t.string :rank

      t.timestamps
    end
  end
end
