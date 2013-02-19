class Users < ActiveRecord::Base
  attr_accessible :card_id, :first_name, :last_name, :sosial_security_number
end
