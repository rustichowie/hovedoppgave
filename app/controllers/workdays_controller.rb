class WorkdaysController < ApplicationController
  
before_filter :get_user
  
  #henter en bruker om params[:user_id] finnes
  def get_user
     @user = User.includes(:workdays).find(params[:user_id]) if params[:user_id]
  end
  
  def log_new_workday
    
  end
  
  #Index action, GET /user/:user_id/workdays
  def index
       
       @prev_class = "enabled"
       @next_class = "enabled"
    
    #sjekker om valgt måned finnes
    if params[:date]
      @date = Date.parse(params[:date])
    else
      @date = Date.today 
    end
    respond_to do |format|
      format.html do
        
          @workdays = Workday.new.get_workdays_by_month(params[:user_id], @date)
          
          #Sjekker om måneden er tom
          if Workday.new.get_workdays_by_month(params[:user_id], @date.advance(months: -1)).empty?
            @prev_class = "disabled"
          end
          if Workday.new.get_workdays_by_month(params[:user_id], @date.advance(months: 1)).empty?
            @next_class = "disabled"
          end
      end
      format.json {render json: @workdays.to_json}
    end
    
    
  end

  #List action, GET /workdays
  #Samme logikk som index
  def list
    @prev_class = "enabled"
       @next_class = "enabled"
    
    if params[:date]
      @date = Date.parse(params[:date])
    else
      @date = Date.today 
    end
    respond_to do |format|
      format.html do
          @workdays = Workday.new.get_workdays_by_month(nil, @date)
          
          if Workday.new.get_workdays_by_month(nil, @date.advance(months: -1)).empty?
            @prev_class = "disabled"
          end
          if Workday.new.get_workdays_by_month(nil, @date.advance(months: 1)).empty?
            @next_class = "disabled"
          end
      end
      format.json {render json: @workdays.to_json}
    end
  end

  #GET /users/:user_id/workdays/:id
  def show 
    @workday = @user.workdays.find(params[:id])
    if @workday.supervisor_hour
      @sum = @workday.supervisor_hour
    else
      @sum = @workday.get_workhour_sum(@workday.date, @user.id)
    end
  end
  
  #GET /users/:user_id/workdays/new
  def new
    @workday = Workday.new
  end

  #POST /users/:user_id/workdays
  def create
    comment = params[:workday][:comment]
    hours = params[:workday][:supervisor_hour]
    @workday = Workday.new(date: Date.today, comment: comment, supervisor_hour: hours, user_id: @user.id)
    if @workday.save
      Log.create(user_id: @user.id, workday_id: @workday.id, action: "user", logtype_id: 2)
      redirect_to action: 'show', id: @workday
    else
        render 'new'
    end
  end


  #GET /users/:user_id/workhours/:id/edit
  def edit 
  end
  
  #POST  /users/:user_id/workhours/:id
  def update
      @workday = Workday.find(params[:id])
      #Sjekker om approved paramenteret er null eller ikke
     if params[:approved] 
            #oppdaterer
            @workday.update_attributes(approved: params[:approved])        
            
            #Logger
            if params[:approved] == true
              Log.create(user_id: @user.id, workday_id: @workday.id, action: "approved", logtype_id: 4)
            else
              Log.create(user_id: @user.id, workday_id: @workday.id, action: "unapproved", logtype_id: 4)
            end
      #du ender opp her om man delvis godkjenner
      else if params[:workday] 
        @workday.update_attributes(comment: params[:workday][:comment], approved: true, supervisor_hour: params[:workday][:supervisor_hour])
        Log.create(user_id: @user.id, workday_id: @workday.id, action: "approved", logtype_id: 2)
    end
    end

      respond_to do |format|
        format.html do
          
          #Sjekker hvor man kom ifra
          if params[:page] or params[:workday][:page] == "index"
            redirect_to action: "index"
          else
            redirect_to action: "list"
          end
          
        end
      format.js
      format.json {render json: @workday.to_json(only: :approved)}
    end
  end
end
