class LogsController < ApplicationController


  #GET /logs
  def index
    @category = params[:category]
    @logtypes = Logtype.all
    @log_message = Log.new.print_log(params[:category])
    
  end
  
  #GET /logs/:id
  def show
  end
  
  
  
end
