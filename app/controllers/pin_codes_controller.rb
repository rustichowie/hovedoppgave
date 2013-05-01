#encoding: utf-8
class PinCodesController < ApplicationController
  
  before_filter :get_users_with_phone
  
  include PinProvider
  
  def get_users_with_phone
    @users = User.where("phone_number != '' ")
  end
  
  
  def new
    @users_without_phone = User.where(phone_number: "")
  end
  
  def create
    if params[:id] == nil
    @users.each do |user|
      run_casper(user.phone_number, user.pin)
    end
    else
      user = User.find(params[:id])
      run_casper(user.phone_number, user.pin)
    end
    
    respond_to do |format|
      format.html {
        redirect_to(new_pin_code_path)
      }
      format.xml { render :xml => @users }
    end
  end
  
end