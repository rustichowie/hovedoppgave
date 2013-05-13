# == Schema Information
#
# Table name: roles
#
#  id                :integer          not null, primary key
#  name              :string(255)
#  description       :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  authorizable_type :string(255)
#  authorizable_id   :integer
#

class Role < ActiveRecord::Base
  using_access_control
  attr_accessible :description, :name
  
  has_many :user
  after_create do
    create_log
  end
  after_destroy do
    delete_log
  end

  #Lager en create logg
  def create_log
    if Role.all.empty?
    unless UserSession.find == nil
    Log.create(user_id: UserSession.find.user.id, message: 
    "#{UserSession.find.user.name} har opprettet en ny rolle med navn: #{self.name}",
     logtype_id: 2)
    end
    end
  end
  #Lager en destroy logg
  def delete_log
    unless UserSession.find == nil
    Log.create(user_id: UserSession.find.user.id, message: 
    "#{UserSession.find.user.name} har slettet rollen: #{self.name}",
     logtype_id: 3)
    end
  end
  
end
