class UserSessionsController < ApplicationController
  filter_resource_access
  
  #ny session
  def new
    @user_session = UserSession.new
  end
  
  #Oppretter en ny bruker session når man logger inn
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      redirect_to workdays_path
    else
      render :action => :new
    end
  end
  
  #sletter session ved utlogging
  def destroy
    current_user_session.destroy
    redirect_to login_path
  end
  
end

