class Card < ActiveRecord::Base
  
  attr_accessible :card_value, :user_id
  belongs_to :user
  validates :card_value, :uniqueness => {:scope => :user_id}
  
  
 
end
