# == Schema Information
#
# Table name: categories
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  tag        :string(255)
#

class Category < ActiveRecord::Base
  attr_accessible :name, :tag
end
