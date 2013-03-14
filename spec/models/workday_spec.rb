# == Schema Information
#
# Table name: workdays
#
#  id              :integer          not null, primary key
#  date            :datetime
#  user_id         :integer
#  comment         :string(255)
#  supervisor_hour :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  approved        :boolean          default(FALSE)
#

require 'spec_helper'

describe Workday do
  pending "add some examples to (or delete) #{__FILE__}"
end
