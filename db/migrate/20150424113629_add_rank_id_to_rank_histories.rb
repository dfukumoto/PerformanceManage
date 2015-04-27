class AddRankIdToRankHistories < ActiveRecord::Migration
  def change
    add_column :rank_histories, :rank_id, :integer
  end
end
