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
  pending "add some examples to (or delete) #{__FILE__}"
end
