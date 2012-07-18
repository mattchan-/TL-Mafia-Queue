# == Schema Information
#
# Table name: votes
#
#  id         :integer         not null, primary key
#  game_id    :integer
#  user_id    :integer
#  approved   :boolean         default(FALSE)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'

describe Vote do
  pending "add some examples to (or delete) #{__FILE__}"
end
