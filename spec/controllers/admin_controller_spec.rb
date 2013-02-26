require 'spec_helper'

describe 'Admin Controller' do
  
  describe 'PUT #update' do
    
  it 'is possible to edit users' do
    @user = User.new(name: "Haavard")
    put :update, { :id => @user.id, :user => { :name => "" } }
    response.should render_template("edit")
    
  end
end

describe 'POST #create' do
  it 'is possible to add new cards' do
    expect {post :create, user: User.new(name: "HRO") }.to change(User,:count).by(1)
  end
end
  describe 'DELETE #destroy' do
    it 'is possible to deaktivate old cards' do
      @card = Card.new(user_id: 2, card_value: "jdsifnwe")
      expect{
      delete :destroy, id: @card        
    }.to change(Card,:count).by(-1)
    end
  end
  
  it 'should have acsess to the database log.'
  it 'should validate username and password when loging in'
end
