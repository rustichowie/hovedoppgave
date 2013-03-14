class Supervisor::WorkdayController < ApplicationController
  
  def index

    @workdays = Workday.new.get_workdays
    
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
