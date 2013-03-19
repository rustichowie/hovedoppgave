# == Schema Information
#
# Table name: log_types
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Logtype < ActiveRecord::Base
  attr_accessible :description, :name
  has_many :logs
  
  
  
  
end
