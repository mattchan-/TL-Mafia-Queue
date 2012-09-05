# == Schema Information
#
# Table name: users
#
#  id              :integer         not null, primary key
#  name            :string(255)
#  email           :string(255)
#  password_digest :string(255)
#  remember_token  :string(255)
#  admin           :boolean         default(FALSE)
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#

class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :password_confirmation
  has_secure_password

  before_save :create_remember_token

  validates :name, presence: true, length: { maximum: 50 },
                   uniqueness: { case_sensitive: false }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence:   true,
                    format:     { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 5 }
  validates :password_confirmation, presence: true

  has_many :hosted_games, foreign_key: "host_id", class_name: "Game"
  has_many :signups, through: :votes, class_name: "Game", source: :game # user.signups returns the array of games the user is signed up for
  has_many :votes                                                       # user.votes returns the array of votes the player has cast
  has_many :posts, foreign_key: "owner_id", dependent: :destroy
  has_many :topics, foreign_key: "owner_id"

  private
  
    def create_remember_token
      begin
        self.remember_token = SecureRandom.urlsafe_base64
      end while User.exists?(remember_token => self.remember_token)
    end
end
