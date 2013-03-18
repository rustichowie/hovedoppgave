# == Schema Information
#
# Table name: workdays
#
#  id              :integer          not null, primary key
#  user_id         :integer          not null
#  comment         :string(255)
#  supervisor_hour :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  approved        :boolean
#  date            :date             not null
#

require 'spec_helper'

describe Workday do
  pending "add some examples to (or delete) #{__FILE__}"
end
