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
#  status_id   :integer         default(1)
#  mini        :boolean
#  normal      :boolean
#  invite      :boolean
#  newbie      :boolean
#  created_at  :datetime        not null
#  updated_at  :datetime        not null
#

class Game < ActiveRecord::Base
  attr_accessible :title, :description, :player_cap, :topic_id, :status_id, :mini, :normal, :invite, :newbie

  validates :title, presence: true, length: { maximum: 50 },
                   uniqueness: { case_sensitive: false }
  validates :description, presence: true
  validates :player_cap, presence: true, numericality: { only_integer: true }
  validates :host_id, presence: true
  validates :topic_id, presence: true
  validates :status_id, presence: true

  belongs_to :host, class_name: "User"
  belongs_to :topic
  belongs_to :status
  has_many :votes
  has_many :players, through: :votes, class_name: "User", source: :user
end
