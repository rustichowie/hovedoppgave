require 'spec_helper'
require 'selenium-webdriver'

describe UsersController do
  include Capybara::DSL
  render_views
  before(:each) do

    visit '/user_sessions/new'
    fill_in 'user_session_email', :with => "h@h.no"
    fill_in 'user_session_password', :with => "1234"
    click_button "Login"
  end
  
  it 'should show all users' do      
    visit '/users'
    response.should render_template('users/index')
  end
  it 'should show a user' do
    visit 'users/3'
    response.should render_template(:show)
  end
  it 'should create user' do
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
    response.should render_template(@user)
  end
  it 'should edit user' do
    @attr = FactoryGirl.attributes_for(:valid_user)
    @new_attr = FactoryGirl.attributes_for(:new_valid_user)
    visit '/users/new'
    fill_in 'user_name', :with => @attr[:name]
    fill_in 'user_email', :with => @attr[:email]
    fill_in 'user_group_id', :with => @attr[:group_id]
    fill_in 'user_role_id', :with => @attr[:role_id]
    fill_in 'user_password', :with => @attr[:password]
    fill_in 'user_password_confirmation', :with => @attr[:password_confirmation]
    click_button "Register"
    @user = User.where(name: "Example User").first
    visit '/users/'+@user.id.to_s+'/edit'
    fill_in 'user_name', :with => @new_attr[:name]
    fill_in 'user_email', :with => @new_attr[:email]
    fill_in 'user_group_id', :with => @new_attr[:group_id]
    fill_in 'user_role_id', :with => @new_attr[:role_id]
    fill_in 'user_password', :with => @new_attr[:password]
    fill_in 'user_password_confirmation', :with => @new_attr[:password_confirmation]
    click_button "Lagre"
    @user.reload
    @user.role_id.should == @new_attr[:role_id]
  end

end
