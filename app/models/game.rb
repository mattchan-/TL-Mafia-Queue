# == Schema Information
#
# Table name: games
#
#  id              :integer         not null, primary key
#  title           :string(255)
#  description     :text
#  maximum_players :integer
#  host_id         :integer
#  running         :boolean
#  signups         :integer
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  category_id     :integer
#

class Game < ActiveRecord::Base
  attr_accessible :description, :maximum_players, :running, :title, :signups, :category_id

  validates :title, presence: true, length: { maximum: 50 },
                   uniqueness: { case_sensitive: false }
  validates :maximum_players, presence: true, numericality: { only_integer: true }
  validates :description, presence: true
  validates :host_id, presence: true
  validates :category_id, presence: true

  belongs_to :host, class_name: "User"
  belongs_to :category
  has_many :votes
  has_many :users, through: :votes, source: :user
end
