# == Schema Information
#
# Table name: posts
#
#  id         :integer         not null, primary key
#  content    :string(255)
#  user_id    :integer
#  game_id    :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class Post < ActiveRecord::Base
  attr_accessible :content, :game_id

  belongs_to :user
  belongs_to :game

  default_scope order: 'posts.created_at ASC'
end