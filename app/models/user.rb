#encoding: utf-8
# == Schema Information
#
# Table name: users
#
#  id                  :integer          not null, primary key
#  name                :string(255)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  employee_id         :integer
#  pin                 :string(255)
#  salt                :string(255)
#  email               :string(255)
#  group_id            :integer          not null
#  role_id             :integer          not null
#  persistence_token   :string(255)      not null
#  single_access_token :string(255)      not null
#  perishable_token    :string(255)      not null
#  login_count         :integer          default(0), not null
#  failed_login_count  :integer          default(0), not null
#  last_request_at     :datetime
#  current_login_at    :datetime
#  last_login_at       :datetime
#  current_login_ip    :string(255)
#  last_login_ip       :string(255)
#  crypted_password    :string(255)      not null
#  active              :boolean          default(TRUE), not null
#  phone_number        :string(20)       not null
#

class User < ActiveRecord::Base

   acts_as_authentic do |c| 
     c.login_field = :phone_number 
   end

  
  attr_accessible :name, :email, :group_id, :role_id, :employee_id, :password, :password_confirmation, :persistence_token, :phone_number
  has_many :cards
  has_many :workhours
  belongs_to :role
  belongs_to :group
  has_many :workdays
  has_many :logs
  accepts_nested_attributes_for :cards
  validates :name, :phone_number, :presence => true
  validates :phone_number, :uniqueness => {:message => "nummeret er allerede tatt"}
  validates :phone_number, :numericality => { :only_integer => true, :message => "må bestå av bare tall"}
  after_create do
    create_log
  end
  
  def create_log
    unless UserSession.find == nil
    Log.create(user_id: self.id, message: "#{UserSession.find.user.name} har opprettet en ny ansatt med navn: #{self.name} den #{self.created_at.strftime("%Y-%m-%d")}", logtype_id: 2)
    else
      Log.create(user_id: user.id, message: "#{self.name} har blitt opprettet den #{self.created_at.strftime("%Y-%m-%d")}", logtype_id: 2)
    end
  end

  def is_admin?
    if self.role_id == 3
      true
    else
      false
    end   
  end
  
  
  
  def role_symbols
    return ["#{self.role.name.underscore}".to_sym]
  end
  
  # Genererer en unik pin til brukeren
  def generate_pin
    r = Random.new
    present = true
    while present
      pin = r.rand(1000...9999)
      users = User.all
      user_pin = users.map {|user| user.pin}
      unless user_pin.include? pin
        present = false
        return pin
      end
    end
  end

end
