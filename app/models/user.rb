# == Schema Information
#
# Table name: users
#
#  id              :integer         not null, primary key
#  name            :string(255)
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  password_digest :string(255)
#  remember_token  :string(255)
#

class User < ActiveRecord::Base
  attr_accessible :name, :password, :password_confirmation
  has_secure_password

  before_save :create_remember_token

  validates :name, presence: true, length: { maximum: 50 },
                   uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true

  has_many :games, foreign_key: "host_id"
  has_many :signups, through: :votes, class_name: "Game", source: :game # user.signups returns the array of games the user is signed up for
  has_many :votes                                                       # user.votes returns the array of votes the player has cast

  private
  
    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
