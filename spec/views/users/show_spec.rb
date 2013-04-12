#encoding: utf-8
require 'spec_helper'


describe "GET show" do
  include Capybara::DSL
  
  let(:user){User.find(3)}
  before(:each) {visit "/users/#{user.id}"}
  describe "when admin is logged in" do
    context "User information" do
      it {should have_selector('h4', text: user.name)}
      it {should have_selector('h4', text: user.group.name)}
      it {should have_selector('h4', text: user.employee_id)}
      it {should have_selector('h4', text: user.email)}
    
      it {should have_selector('h5', text: user.last_login_ip)}
      it {should have_selector('h5', text: user.last_login_at)}
    end
    context "Workdays" do
      it {should render_template(partial: 'workday')}
    end
  
    context "side action menu" do
      it {should render_template(partial: 'sidebar')}
      it {should have_selector('div', id: "sidebar")}
      it {should have_link('Rediger ansatt', href: edit_user(user))}
      it {should have_link('Rediger ansattes kort'), href: edit_user_card(user, user.card)}

    end
    
    context "top action menu" do
      it {should render_template(partial: 'supervisor_buttonbar')}
      it {should have_link("Hjem", users_path)}
      it {should have_link("Logg", logs_path)}
    end
    
  end
  
  describe "when an normal employee is logged in" do
    context "User information" do
      it {should have_selector('h4', text: user.name)}
      it {should have_selector('h4', text: user.group.name)}
      it {should have_selector('h4', text: user.employee_id)}
      it {should have_selector('h4', text: user.email)}
    
      it {should_not have_selector('h5', text: user.last_login_ip)}
      it {should_not have_selector('h5', text: user.last_login_at)}
    end
    context "Workdays" do
      it {should render_template(partial: 'workday')}
    end
  
    context "side action menu" do
      it {should_not render_template(partial: 'sidebar')}
      it {should_not have_selector('div', id: "sidebar")}
      it {should_not have_link('Rediger ansatt', href: edit_user(user))}
      it {should_not have_link('Rediger ansattes kort'), href: edit_user_card(user, user.card)}

    end
    
    context "top action menu" do
      it {should render_template(partial: 'user_buttonbar')}
      it {should have_link("Arbeidstimer", user_workdays_path(user))}
      it {should have_link("Lønnslipper", user_paychecks_path(user))}
    end
  end
  
 
end
