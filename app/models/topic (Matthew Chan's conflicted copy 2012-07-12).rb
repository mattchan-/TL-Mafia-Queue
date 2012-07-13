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

  accepts_nested_attributes_for :posts
  accepts_nested_attributes_for :game, reject_if: lambda { |a| a[:player_cap].blank? }

  default_scope order: 'topics.updated_at DESC'
end