class WorkdaysController < ApplicationController
  
before_filter :get_user
  before_filter :pager
  #henter en bruker om params[:user_id] finnes
  def get_user
     @user = User.includes(:workdays).find(params[:user_id]) if params[:user_id]
  end
  
  def approve_all
    if @user
      workdays = @user.workdays
    else
      workdays = Workday.where("MONTH(date) = ? AND YEAR(date) = ?",
                                  @date.month, @date.year)
    end  
    workdays.each do |workday|
      if workday.approved == nil
        workday.update_attributes(approved: true)
      end
    end
    
    respond_to do |format|
      format.html do    
          if @user
            redirect_to action: "index", user_id: @user
          else
            redirect_to action: "index"
          end
      end
    end
    
  end
  
  def pager
    @prev_class = "enabled"
    @next_class = "enabled"
    if params[:date]
      @date = Date.parse(params[:date])
    else
      @date = Date.today 
    end
    
    if Workday.new.get_workdays_by_month(@user, @date.advance(months: -1)).empty?
         @prev_class = "disabled"
    end
    if Workday.new.get_workdays_by_month(@user, @date.advance(months: 1)).empty?
         @next_class = "disabled"
    end
  end
  
  #Index action, GET /user/:user_id/workdays
  def index

    respond_to do |format|
      format.html do       
          @workdays = Workday.new.get_workdays_by_month(@user, @date)
      end
      format.json {render json: @workdays.to_json}
    end
    
    
  end

  #GET /users/:user_id/workdays/:id
  def show 
    if @user
      @workday = @user.workdays.find(params[:id])
    else
      @workday = Workday.find(params[:id])
      @user = @workday.user
    end
    
    if @workday.supervisor_hour
      @sum = @workday.supervisor_hour
    else
      @sum = @workday.get_workhour_sum(@workday.date, @workday.user.id)
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
    @workday = Workday.new(date: Date.today, comment: comment, supervisor_hour: hours, user_id: @user.id, approved: true)
    if @workday.save
      Log.create(user_id: current_user.id, workday_id: @workday.id, effected_user_id: @user.id, action: "user", logtype_id: 2)
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
              Log.create(user_id: current_user.id, workday_id: @workday.id, effected_user_id: @user.id,action: "approved", logtype_id: 6)
            else
              Log.create(user_id: current_user.id, workday_id: @workday.id, effected_user_id: @user.id,action: "unapproved", logtype_id: 6)
            end
      #du ender opp her om man delvis godkjenner
      else if params[:workday] 
        @workday.update_attributes(comment: params[:workday][:comment], approved: true, supervisor_hour: params[:workday][:supervisor_hour])
        Log.create(user_id: current_user.id, effected_user_id: @user.id, workday_id: @workday.id, action: "approved", logtype_id: 6)
    end
    end

      respond_to do |format|
        format.html do
            redirect_to action: "index", user_id: nil
        end
      format.js
      format.json {render json: @workday.to_json(only: :approved)}
    end
  end
end
