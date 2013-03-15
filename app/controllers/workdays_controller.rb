class WorkdaysController < ApplicationController
  
before_filter :get_user
  
  def get_user
     @user = User.includes(:workdays).find(params[:user_id]) if params[:user_id]
  end
  
  def index
    @workdays = Workday.new.get_workdays(params[:user_id])
  end

  def list
    @workdays = Workday.new.get_workdays(nil)
  end

  def show 
    @workday = @user.workdays.find(params[:id])
    @sum = @workday.get_workhour_sum(@workday.date, @user.id)
  end
  

  def new
    @workday = Workday.new
  end

  def create
    comment = params[:workday][:comment]
    hours = params[:workday][:supervisor_hour]
    @workday = Workday.new(date: Date.today, comment: comment, supervisor_hour: hours, user_id: @user.id)
    if @workday.save
      redirect_to action: 'show', id: @workday
    else
        render 'new'
    end
  end

  def edit
    
    session[:return_to] ||= request.referer
  end

  def update
    @workday = Workday.find(params[:id])
    #@workday.approved = true
    if @workday.update_attributes(approved: true)
      if params[:page] == "index"
        redirect_to action: 'index'
      else
        redirect_to action: 'list'
      end
    else
      render 'index'
    end
  end

  def destroy
  end
end
