#encoding: utf-8
class PinCodesController < ApplicationController
  
  respond_to :html
  before_filter :get_users_with_phone
  include PinProvider
  
  #Henter ut alle ansatte med lagret tlf
  def get_users_with_phone
    @users = User.where("phone_number != '' ")
  end
  
  #hovedside for distribuering av pinkoder
  def index
    @users_without_phone = User.where("phone_number = '' OR phone_number is null")
  end
  
  #Sender ut pinkoder, enten til enkel bruker eller alle
  def create
    if params[:id] == nil
    @users.each do |user|
      run_casper(user.phone_number, user.pin)
    end
    else
      user = User.find(params[:id])
      run_casper(user.phone_number, user.pin)
    end
    
    respond_with do |format|
      format.html {
        redirect_to(pin_codes_path)
      }
    end
  end
  
end