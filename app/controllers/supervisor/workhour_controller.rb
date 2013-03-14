class Supervisor::WorkhourController < ApplicationController
  
  def index

    @hour = Workhour.new.group_workhours
    
  end

  def show
    
    @hour = User.includes(:workhours).find(params[:id])
    
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
