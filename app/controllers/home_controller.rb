class HomeController < ApplicationController

  def index
  end
  
  def show
      @message = params[:value]
      #redirect_to('/', :notice => "Success")
      flash[:notice] = "Success!".html_safe
      render :action => 'index'
  end
  
  
end
