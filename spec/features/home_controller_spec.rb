require 'spec_helper'




describe "Registration" do
  describe 'automatic regitration' do
    #before {visit root_path}
    it "compares swiped card with database" do
      card = Card.create(user_id: 1, card_value: "blob")
      card.check(card.card_value).should = true
      
    end
    it 'should redirect to unknowncard site'
    it 'should add a start time when swping card'
    it 'should add a stop time is started'
    it 'should except userid and pincode'
  end
end
