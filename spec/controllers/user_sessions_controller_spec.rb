require 'spec_helper'

describe UserSessionsController do
  render_views
  before(:each) do
    
  end
  
  it 'should redirect to login when not logged in' do
    visit '/users'
    response.should render_template('user_sessions/new')
  end
  it 'should redirect to error page when logged in without access' do
    visit '/user_sessions/new'
    fill_in 'user_session_email', :with => "hav@h.no"
    fill_in 'user_session_password', :with => "1234"
    click_button "Login"
    visit 'users/2'
    response.should render_template('shared/access_denied')
  end
  it 'should show content when logged in with access' do
    visit '/user_sessions/new'
    fill_in 'user_session_email', :with => "h@h.no"
    fill_in 'user_session_password', :with => "1234"
    click_button "Login"
    visit 'users/2'
    response.should render_template('users/show')
  end
  it 'should not log in without correct credentials' do
    visit '/user_sessions/new'
    fill_in 'user_session_email', :with => "halla@h.no"
    fill_in 'user_session_password', :with => "1234"
    click_button "Login"
    visit 'users/2'
    response.should render_template('user_sessions/new')
  end
end
