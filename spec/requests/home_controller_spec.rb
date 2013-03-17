require 'spec_helper'



describe "Registration" do
  include Capybara::DSL

  before {visit "/"}
  
  describe 'automatic regitration' do
    

    let(:user) {FactoryGirl.create(:user)}
    
    it 'should render automatic register website' do
      get "/"
      response.should render_template("/")
    end
    
    it 'should add a start time when swiping card' do
      Card.create(user_id: user.id, card_value: "123")
      post "/", :value => "123"
      expect(response.body).to include("Vellykket registrering: startet")
    end
    
    it 'should add a stop time if started' do
      Card.create(user_id: user.id, card_value: "123")
      Workhour.create(start: Time.now, stop: nil, user_id: user.id) 
      post "/", :value => "123"
      expect(response.body).to include("Vellykket registrering: stoppet")
    end
    
    it 'should redirect to unknowncard site if card is unknown' do
      post "/", :value => "123"
      response.should render_template("unknown")
    end
  end

  before {visit "/manual"}
  
  describe 'manual registration' do
    
    it 'should except userid and pincode' do

    end
  end
  
end
