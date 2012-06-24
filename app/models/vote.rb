# == Schema Information
#
# Table name: votes
#
#  id         :integer         not null, primary key
#  game_id    :integer
#  user_id    :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class Vote < ActiveRecord::Base
  attr_accessible :game_id, :user_id
  belongs_to :user
  belongs_to :game # votes are deleted when a game is deleted.
end
