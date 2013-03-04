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

class LogType < ActiveRecord::Base
  attr_accessible :description, :name
  belongs_to :logs
  
end
