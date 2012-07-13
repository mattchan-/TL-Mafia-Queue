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
  attr_accessible :user_id, :game_id
  validates :user_id, uniqueness: { scope: :game_id }
  belongs_to :user
  belongs_to :game # votes are deleted when a game is deleted.
  after_save :close_signups

  def close_signups
    self.game.touch
    self.game.topic.touch
    if self.game.players.count >= self.game.player_cap
      self.game.update_attributes(status_id: 2)
    end
  end

end
