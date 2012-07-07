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

require 'spec_helper'

describe Game do
  pending "add some examples to (or delete) #{__FILE__}"
end
