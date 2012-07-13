# == Schema Information
#
# Table name: games
#
#  id          :integer         not null, primary key
#  title       :string(255)
#  description :text
#  player_cap  :integer
#  host_id     :integer
#  topic_id    :integer
#  mini        :boolean
#  invite      :boolean
#  category    :string(255)
#  status      :string(255)     default("Signups Open")
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

class Game < ActiveRecord::Base
  attr_accessible :player_cap, :topic_id, :mini, :invite, :category, :status

  validates :player_cap, presence: true, numericality: { only_integer: true }
  validates :host_id, presence: true
  validates :topic_id, uniqueness: true
  validates :category, inclusion: %w[Normal Themed Newbie]
  validates :status, inclusion: ['Signups Open', 'Pending', 'Running', 'Completed']

  belongs_to :host, class_name: "User"
  belongs_to :topic
  has_many :votes
  has_many :players, through: :votes, class_name: "User", source: :user

  def category_tag
    tag = ""
    tag += '[M]' if self.mini?

    case self.category
    when 'Normal'
      tag += '[N]'
    when 'Themed'
      tag += '[T]'
    when 'Newbie'
      tag += '[W]'
    end

    tag += '[I]' if self.invite?
    return tag
  end
end
