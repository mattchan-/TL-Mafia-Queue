# == Schema Information
#
# Table name: games
#
#  id              :integer         not null, primary key
#  title           :string(255)
#  description     :text
#  maximum_players :integer
#  host_id         :integer
#  category_id     :integer
#  status_id       :integer
#  signups         :integer
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#

require 'spec_helper'

describe Game do
  pending "add some examples to (or delete) #{__FILE__}"
end
