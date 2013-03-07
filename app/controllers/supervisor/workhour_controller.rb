class Supervisor::WorkhourController < ApplicationController
  
  def index

    @collection = Workhour.all
    
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
