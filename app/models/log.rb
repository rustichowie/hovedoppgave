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

class Log < ActiveRecord::Base
  attr_accessible :card_id, :int, :logtype_id, :user_id, :workhours_id
  has_one :log_type
  
  #Søke metode, skal implementeres senere
  def search(params)
   
  end
  
end
