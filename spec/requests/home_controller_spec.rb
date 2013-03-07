require 'spec_helper'




describe "Registration" do
  include Capybara::DSL
  before {visit "/"}
  
  describe 'automatic regitration' do
    
<<<<<<< HEAD
    it "compares swiped card with database" do
      card = Card.create(user_id: 1, card_value: "blob")
      fill_in "card_input_value", :with => card.card_value
      page.click_on('submit')
      card.should_receive(:check_card_value).with(card.card_value).and_return(false)
      
    end
    it 'should redirect to unknowncard site if card is unknown' do
      post root_path
      card = Card.create(user_id: 1, card_value: "card")
      card.stub(:check_card_value).with("card").and_return(false)
      page.should_receive(:alert).with("Error message!")
=======
    let(:user) {User.create(name: "yolo")}
    
    it 'should render automatic register website' do
      get "/"
      response.should render_template("/")
>>>>>>> ebecf7c3d0aefe9b4d4bb6d451dd29ed8d3cee34
    end
    
    it 'should add a start time when swiping card' do
<<<<<<< HEAD
      card = Card.create(user_id: 1, card_value: "start")
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
=======
      Card.create(user_id: user.id, card_value: "123")
      post "/", :value => "123"
      expect(response.body).to include("Vellykket registrering: startet")
    end
>>>>>>> ebecf7c3d0aefe9b4d4bb6d451dd29ed8d3cee34
    
    it 'should add a stop time if started' do
      Card.create(user_id: user.id, card_value: "123")
      Workhour.create(start: Time.now, stop: nil, user_id: 1) 
      post "/", :value => "123"
      expect(response.body).to include("Vellykket registrering: stoppet")
    end
    
    it 'should redirect to unknowncard site if card is unknown' do
      post "/", :value => "123"
      response.should render_template("unknown")
    end
  end
<<<<<<< HEAD
  before {visit "/manual"}
=======
  
>>>>>>> ebecf7c3d0aefe9b4d4bb6d451dd29ed8d3cee34
  describe 'manual registration' do
    
    it 'should except userid and pincode' do
<<<<<<< HEAD
      post manual_path
      fill_in "id", :with => "1234"
      fill_in "pw", :with => "7989"
      page.click_on('manual_submit')
=======
>>>>>>> ebecf7c3d0aefe9b4d4bb6d451dd29ed8d3cee34
    end
  end
  
end
