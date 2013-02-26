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

class Workhours < ActiveRecord::Base
  attr_accessible :count, :start, :stop, :user_id
  belongs_to :user
end
