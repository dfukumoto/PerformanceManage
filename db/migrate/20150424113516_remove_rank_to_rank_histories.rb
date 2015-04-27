class RemoveRankToRankHistories < ActiveRecord::Migration
  def change
    remove_column :rank_histories, :rank, :string
  end
end
