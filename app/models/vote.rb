# == Schema Information
#
# Table name: votes
#
#  id         :integer         not null, primary key
#  game_id    :integer
#  user_id    :integer
#  approved   :boolean         default(FALSE)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class Vote < ActiveRecord::Base
  attr_accessible :user_id, :game_id, :approved
  validates :user_id, uniqueness: { scope: :game_id }
  belongs_to :user
  belongs_to :game # votes are deleted when a game is deleted.
  after_save :close_signups
  before_create :auto_set_approval

  def close_signups
    self.game.touch
    if self.game.players.count >= self.game.player_cap
      self.game.update_attributes(status_id: 2)
    end
  end

  def auto_set_approval
    self.approved = true unless self.game.invite?
  end
end
