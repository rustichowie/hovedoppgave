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
#

class User < ActiveRecord::Base

   acts_as_authentic #do |c|
    #c.validate_email_field = false
    #c.validate_login_field = true
    #make sure that one workshop wont be able to have two users of the same name
    #c.validations_scope = :workshop_id
    #c.logged_in_timeout=30.minutes;
    #c.maintain_sessions=false
    #c.ignore_blank_passwords=false
  #end

  
  attr_accessible :name, :email, :group_id, :role_id, :employee_id, :password, :password_confirmation
  has_many :cards
  has_many :workhours
  belongs_to :role
  belongs_to :group
  has_many :workdays
  has_many :logs
  
  validates :name, :presence => true
  
  def role_symbols
    return ["#{self.role.name.underscore}".to_sym]
  end

  
end
