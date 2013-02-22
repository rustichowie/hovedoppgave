class Card < ActiveRecord::Base
  
  attr_accessible :card_value, :user_id
  belongs_to :user
  validates :card_value, :presence => true, :uniqueness => {:scope => :user_id}
  validates :user_id, :presence => true
  
 
end
