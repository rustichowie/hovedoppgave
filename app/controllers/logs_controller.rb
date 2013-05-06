class LogsController < ApplicationController
filter_resource_access
respond_to :html, :json, :js
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
    
    
    @logs = Log.new.print_log(cat, search, from, to)
    respond_with(@logs)
  rescue ActiveRecord::StatementInvalid
     flash[:notice] = "Encoding error"
     redirect_to action: "index"
  end
  
  
  
end
