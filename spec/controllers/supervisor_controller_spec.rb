require 'spec_helper'

describe 'Supervisor controller' do
  describe 'GET #index' do
      it 'should show a list of workhours' do
        workhours = [Workhour.create(user_id: 2), Workhour.create(user_id: 2), Workhour.create(user_id: 2)]
        get :index
        assigns(:work_hours).should eq([workhours])
      end
    it "renders the :index view" do
    get :index
    response.should render_template :index
  end
end
  describe 'POST #create' do
    it 'is possible to approve workhours' do
      expect {post :create, workhour: Workhour.new(user_id: 2, count: 5) }.to change(Workhour,:count).by(1)
    end
    it 'is possible to unapprove workhours' do 
      post :create, workhour: Workhour.new(user_id: 2, count: 5)
      response.should redirect_to :index
    end
  end
  
end
