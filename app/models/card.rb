# == Schema Information
#
# Table name: cards
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  card_value :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Card < ActiveRecord::Base
  
  attr_accessible :card_value, :user_id
  belongs_to :user
  validates :card_value, :presence => true, :uniqueness => {:scope => :user_id}
  validates :user_id, :presence => true
  
  def check_card_value(value, pin)
    user = User.where(pin: pin).first
    user_id = user.id
    if user_id and value
      Card.create(user_id: user_id, card_value: value)
      return true
    else
      return false
    end
  end
 
end
