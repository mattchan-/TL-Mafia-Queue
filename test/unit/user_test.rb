# == Schema Information
#
# Table name: users
#
#  id                     :integer         not null, primary key
#  name                   :string(255)
#  email                  :string(255)
#  password_digest        :string(255)
#  remember_token         :string(255)
#  admin                  :boolean         default(FALSE)
#  created_at             :datetime        not null
#  updated_at             :datetime        not null
#  password_reset_token   :string(255)
#  password_reset_sent_at :datetime
#  approved               :boolean         default(FALSE)
#  host_priviliges        :boolean         default(FALSE)
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
