# == Schema Information
#
# Table name: games
#
#  id              :integer         not null, primary key
#  title           :string(255)
#  description     :text
#  maximum_players :integer
#  host_id         :integer
#  running         :boolean
#  signups         :integer
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  category_id     :integer
#

require 'spec_helper'

describe Game do
  pending "add some examples to (or delete) #{__FILE__}"
end
