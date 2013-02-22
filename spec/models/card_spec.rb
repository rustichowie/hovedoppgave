require 'spec_helper'

describe Card do
  it 'should have a user id' do
    Card.new(user_id: nil, card_value: "d").should_not be_valid
  end
  it 'is invalid without a card value' do
    Card.new(user_id: 2).should_not be_valid
  end
  it 'is invalid if card_value and user_id is not unique' do
    card = Card.create(user_id: 4, card_value: "hei")
    Card.new(user_id: 4, card_value: "hei").should_not be_valid
  end
  
end
