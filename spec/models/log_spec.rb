# == Schema Information
#
# Table name: logs
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  card_id      :integer
#  logtype_id   :integer
#  workhours_id :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'spec_helper'

describe Log do
  pending "add some examples to (or delete) #{__FILE__}"
end