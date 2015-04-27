class RankHistory < ActiveRecord::Base
  belongs_to :user
  belongs_to :rank_master
end
