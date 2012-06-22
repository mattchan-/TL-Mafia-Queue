class Vote < ActiveRecord::Base
  attr_accessible :game_id, :user_id
  belongs_to :user
  belongs_to :game # votes are deleted when a game is deleted.
end
