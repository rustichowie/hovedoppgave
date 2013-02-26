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
#

class User < ActiveRecord::Base
  
  attr_accessible :name
  has_many :cards
  has_many :workhours
  
  validates :name, :presence => true
end
