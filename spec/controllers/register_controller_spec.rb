require 'spec_helper'
require 'authlogic/test_case'


describe RegisterController do
  include Capybara::DSL
  render_views
  before {visit "/"}
  
  describe 'automatic regitration' do
    

    #let(:user) {FactoryGirl.create(:valid_user)}
    #let(:user_session) {FactoryGirl.create(:user_session)}
    before(:each) do
      visit '/user_sessions/new'
      fill_in 'user_session_email', :with => "h@h.no"
      fill_in 'user_session_password', :with => "1234"
      click_button "Login"
      @attr = FactoryGirl.attributes_for(:valid_user)
      visit '/users/new'
      fill_in 'user_name', :with => @attr[:name]
      fill_in 'user_email', :with => @attr[:email]
      fill_in 'user_group_id', :with => @attr[:group_id]
      fill_in 'user_role_id', :with => @attr[:role_id]
      fill_in 'user_password', :with => @attr[:password]
      fill_in 'user_password_confirmation', :with => @attr[:password_confirmation]
      click_button "Register"
      @user = User.where(name: "Example User").first
    end
    
    it 'should render automatic register website' do
      visit '/'
      response.should render_template("/")
    end
    
    it 'should add a start time when swiping card' do
      Card.create(user_id: @user.id, card_value: "123")
      post :register, :value => "123"
      expect(response.body).to include("startet")
    end
    
    it 'should add a stop time if started' do
      Card.create(user_id: @user.id, card_value: "123")
      Workday.create(user_id: @user.id, date: Date.today)
      workday = Workday.where(user_id: @user.id).first
      Workhour.create(start: Time.now, stop: nil, user_id: @user.id, workday_id: workday.id) 
      post :register, :value => "123"
      expect(response.body).to include("stoppet")
    end
    
    it 'should redirect to unknowncard site if card is unknown' do
      post :register, :value => "123"
      response.should render_template("card_register")
    end
  end

  before {visit "/manual"}
  
  describe 'manual registration' do
    
    it 'should except userid and pincode' do

    end
  end
  
end
