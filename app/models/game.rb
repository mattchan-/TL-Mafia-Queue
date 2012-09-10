# == Schema Information
#
# Table name: games
#
#  id         :integer         not null, primary key
#  title      :string(255)
#  player_cap :integer
#  host_id    :integer
#  mini       :boolean
#  invite     :boolean
#  category   :string(255)
#  status_id  :integer         default(1)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class Game < ActiveRecord::Base
  attr_accessible :title, :player_cap, :mini, :invite, :category, :status_id

  validates :title, presence: true, length: { maximum: 50 }
  validates :player_cap, presence: true, numericality: { only_integer: true }
  validates :host_id, presence: true
  validates :category, inclusion: %w[Normal Themed Newbie]
  validates :status_id, inclusion: (1..4)

  before_save :set_mini_status
  belongs_to :host, class_name: "User"
  has_many :votes
  has_many :players, through: :votes, class_name: "User", source: :user
  has_many :posts, dependent: :destroy

  accepts_nested_attributes_for :posts

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
    return tag
  end

  def set_mini_status
    if self.category == 'Newbie' || self.player_cap > 18
      self.mini = false
    else
      self.mini = true
    end
    return true
  end

  def status
    case self.status_id
    when 1
      "Signups Open"
    when 2
      "Pending"
    when 3
      "Running"
    when 4
      "Completed"
    end
  end

  def approved_players
    votes = self.votes
    array = []
    votes.each { |vote| array << vote.user if vote.approved? }
    return array    
  end

  def self.sort_for_index(sort, direction)
    if(sort == "updated_at") 
      return Game.order("updated_at " + direction)
    elsif (sort == "status")
      return Game.order("games.status_id " + direction)
    else 
      return Game.order("updated_at DESC")
    end
  end
end
