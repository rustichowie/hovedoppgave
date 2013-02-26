# == Schema Information
#
# Table name: workhours
#
#  id         :integer          not null, primary key
#  start      :datetime
#  stop       :datetime
#  user_id    :integer          not null
#  count      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Workhours do
  it 'should have a user ' do
    Workhour.new(user_id: nil).should_not be_valid
  end
end
