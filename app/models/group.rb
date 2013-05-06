# == Schema Information
#
# Table name: groups
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Group < ActiveRecord::Base
  attr_accessible :name
  has_many :users
  
  after_create do
  create_log
  end
  after_destroy do
  delete_log
  end
  
  def delete_log
    unless UserSession.find == nil
      Log.create(user_id: UserSession.find.user.id, message: "#{UserSession.find.user.name} har slettet avdelingen: #{self.name}", logtype_id: 3)
    end
  end
  
  def create_log
    unless UserSession.find == nil
      Log.create(user_id: UserSession.find.user.id, message: "#{UserSession.find.user.name} har opprettet en ny avdeling med navn: #{self.name}", logtype_id: 2)
    end
  end
  
end
