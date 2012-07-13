# == Schema Information
#
# Table name: topics
#
#  id         :integer         not null, primary key
#  title      :string(255)
#  owner_id   :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class Topic < ActiveRecord::Base
  attr_accessible :title

  validates :title, presence: true, length: { maximum: 50 }
  belongs_to :owner, class_name: "User"
  has_one :game
  has_many :posts
  

  def self.sort_for_index(sort, direction)
    if(sort == "updated_at") 
      return Topic.order("updated_at " + direction)
    elsif (sort == "status") 
      return (Topic.all_games(direction) + Topic.nil_game) if direction == 'ASC'
      return (Topic.nil_game + Topic.all_games(direction)) if direction == 'DESC'
    else 
      return Topic.order("updated_at DESC")
    end
  end

  def self.all_games(direction)
  	joins(:game).order("games.status_id " + direction + ", topics.updated_at desc")
  end

  def self.nil_game
    where("not exists (select 1 from games where games.topic_id = topics.id)")
  end
	
  accepts_nested_attributes_for :posts 
  accepts_nested_attributes_for :game#, reject_if: lambda { |a| a[:player_cap].blank? }
end