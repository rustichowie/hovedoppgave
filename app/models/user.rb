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
#

class User < ActiveRecord::Base
  
  attr_accessible :name, :email, :group_id, :role_id, :employee_id
  has_many :cards
  has_many :workhours
  belongs_to :role
  belongs_to :group
  
  validates :name, :presence => true
end
