require 'spec_helper'


  describe "log pages" do
    include Capybara::DSL

    
    before {visit login_path}
    
    describe "with valid permition" do
      let(:user) {User.find(3)}
      before do
        fill_in "user_session_email",    with: user.email
        fill_in "user_session_password", with: "1234"
        click_button "Login"
      end
      before {visit "/logs"}
      describe "Index" do
      it "should show log entryes based on date" do
        
        page.should have_selector("table#log-table") do |table|
          table.should have_selector("tr.log-entries")
        end
      end
      it "should have a search form" do
        page.should have_selector('form', action: "/logs", method: "get")
      end
      it "can show log entryes based on category" do
        Log.create(user_id: 2, logtype_id: 3)
        page.should have_selector('select#categories')
        select "Sletting", from: "categories"
        page.should have_selector('tr.log-entries td', text: "Slettet")
        page.should_not have_selector("tr.log-entries td", text: "Opprettet")
      end
      end
    end
  end


