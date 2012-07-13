# == Schema Information
#
# Table name: games
#
#  id         :integer         not null, primary key
#  player_cap :integer
#  host_id    :integer
#  topic_id   :integer
#  mini       :boolean
#  invite     :boolean
#  category   :string(255)
#  status_id  :integer         default(1)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'

describe Game do
  pending "add some examples to (or delete) #{__FILE__}"
end
