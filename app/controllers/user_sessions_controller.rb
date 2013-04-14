class UserSessionsController < ApplicationController
  filter_resource_access
  
  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      redirect_to workdays_path
    else
      render :action => :new
    end
  end

  def destroy
    current_user_session.destroy
    redirect_to login_path
  end
  
end

