class HomeController < ApplicationController


  def index
  end
  
  def automatic_register
      @message = ""
      if params[:value] != nil
        @message = "Suksess!"
      end
      #redirect_to('/', :notice => "Success")
      #flash[:notice] = "Success!".html_safe
      
      render :action => 'index'
  end
  
  def manual_register
    @message = params[:id]
  end
  
end
