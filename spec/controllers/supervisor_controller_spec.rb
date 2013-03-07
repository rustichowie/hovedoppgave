require 'spec_helper'

describe Supervisor::WorkhourController do
  describe 'GET #index' do
    let(:workhours) {Workhour.all}
      it 'should show a list of workhours' do       
        get :index
        assigns(:workhour).should eq(workhours)
      end
    it "renders the :index view" do
    get :index
    response.should render_template :index
  end
end

  describe 'PUT #update' do
    
    
    let(:hour) {FactoryGirl.create(:workhour)}
    it 'is possible to approve workhours' do
      @workhour = { approved: true}
    put :update, :id => hour, :workhour => @workhour
    hour.reload
    hour.approved.should eq(true)
    end
    
    it 'is possible to unapprove workhours' do 
      @workhour = { approved: false, comment: "You did not work on this day!"}
    put :update, :id => hour, :workhour => @workhour
    hour.reload
    hour.approved.should eq(false)
    hour.comment.should_not eq(nil)
    end
    it 'is possible to partialy approve workhours' do
      @workhour = { :supervisor_hour => 8, :comment => "You did not work then." }
    put :update, :id => hour, :workhour => @workhour
    hour.reload
    hour.supervisor_hour.should eq(@workhour[:supervisor_hour])
    hour.comment.should  eq(@workhour[:comment]) 
    end
    
  end
  
  describe 'POST #create' do
    
    it 'should be able to create a new workhour instance' do
      expect{
        post :create, workhour: FactoryGirl.create(:workhour)
      }.to change(Workhour, :count).by(1)
      
    end
    
  end
  
end
