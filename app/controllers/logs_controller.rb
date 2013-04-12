class LogsController < ApplicationController


  #GET /logs
  def index
    @category = params[:category]
    @logtypes = Logtype.all
    
    if params["datepicker-from"] != ""
      from = params["datepicker-from"]
    end
    if params["datepicker-to"] != ""
    to = params["datepicker-to"]
    end
    if params[:category] != ""
      cat = params[:category]
    end
    if params[:search] != ""
      search = params[:search]
    end
    
    
    @log_message = Log.new.print_log(cat, search, from, to)
    respond_to do |format|
    format.html 
    format.js
  end
  rescue ActiveRecord::StatementInvalid
     flash[:notice] = "Encoding error"
     redirect_to action: "index"
  end
  
  
  
end
