# == Schema Information
#
# Table name: users
#
#  id                  :integer          not null, primary key
#  name                :string(255)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  employee_id         :integer
#  pin                 :string(255)
#  salt                :string(255)
#  email               :string(255)
#  group_id            :integer          not null
#  role_id             :integer          not null
#  persistence_token   :string(255)      not null
#  single_access_token :string(255)      not null
#  perishable_token    :string(255)      not null
#  login_count         :integer          default(0), not null
#  failed_login_count  :integer          default(0), not null
#  last_request_at     :datetime
#  current_login_at    :datetime
#  last_login_at       :datetime
#  current_login_ip    :string(255)
#  last_login_ip       :string(255)
#  crypted_password    :string(255)      not null
#  active              :boolean          default(TRUE), not null
#  phone_number        :string(20)
#  remote_id           :string(45)
#

require 'spec_helper'

describe User do
      it "should have a name" do
        foo = User.new(:name=>"")
        foo.should_not be_valid
      end
      
    
    
end
