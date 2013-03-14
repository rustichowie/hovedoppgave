# == Schema Information
#
# Table name: users
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  employee_id :integer
#  pin         :string(255)
#  salt        :string(255)
#  email       :string(255)
#  group_id    :integer          not null
#  role_id     :integer          not null
#

require 'spec_helper'

describe User do
      it "should have a name" do
        foo = User.new(:name=>"")
        foo.should_not be_valid
      end
      
    
    
end
