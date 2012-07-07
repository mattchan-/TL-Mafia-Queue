# == Schema Information
#
# Table name: posts
#
#  id         :integer         not null, primary key
#  content    :string(255)
#  owner_id   :integer
#  topic_id   :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class Post < ActiveRecord::Base
  attr_accessible :content, :topic_id

  validates :content, presence: true
  
  belongs_to :owner, class_name: "User"
  belongs_to :topic

  default_scope order: 'posts.created_at ASC'
end
