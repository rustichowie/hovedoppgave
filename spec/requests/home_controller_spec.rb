require 'spec_helper'




describe "Registration" do
  include Capybara::DSL
  before {visit "/"}
  
  
  describe 'automatic regitration' do
    
    it "compares swiped card with database" do
      card = Card.create(user_id: 1, card_value: "blob")
      fill_in "card_input_value", :with => card.card_value
      page.click_on('submit')
      card.should_receive(:check_card_value).with(card.card_value)
      
    end
    it 'should redirect to unknowncard site if card is unknown' do
      post root_path
      card = Card.create(user_id: 1, card_value: "card")
      card.stub(:check_card_value).with("card").and_return(false)
      page.should_receive(:alert).with("Error message!")
    end
    it 'should add a start time when swiping card' do
      card = Card.create(user_id: 1, card_value: "blob")
      fill_in "card_input_value", :with => card.card_value
      page.click_on('submit')
      card.stub(:check_card_value).with("card").and_return(true)
      card.should_receive(:change_time).with(card.card_value).and_return("start")
  end
      
  it 'should add a stop time if started' do
      card = Card.create(user_id: 1, card_value: "blob")
      fill_in "card_input_value", :with => card.card_value
      page.click_on('submit')
      card.stub(:check_card_value).with("card").and_return(true)
      card.should_receive(:change_time).with(card.card_value).and_return("stop")
  end
    
  end
  describe 'manual registration' do
    it 'should except userid and pincode' do
      post manual_path
      fill_in "id", "1234"
      fill_in "pw", "7989"
      page.click_on('manual_submit')
    end
  end
end
