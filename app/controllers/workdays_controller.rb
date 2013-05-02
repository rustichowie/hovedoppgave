#encoding: utf-8

class WorkdaysController < ApplicationController
  filter_resource_access
  
  before_filter :get_user, except: :check_group
  
  before_filter :check_group, only: [:index, :new, :edit]
  include DateModul
  before_filter :pager
  
  #henter en bruker om params[:user_id] finnes
  def get_user
     @user = User.includes(:workdays).find(params[:user_id]) if params[:user_id]
  end

 def check_group
    unless current_user.is_admin?
      if params[:user_id]
        if User.find(params[:user_id]).group_id != current_user.group_id
          flash[:notice] = "Du har ikke tilgang på denne ansatte"
          redirect_to action: 'index', user_id: nil
        end
      else if params[:id]
          if Workday.find(params[:id]).user.group_id != current_user.group_id
            flash[:notice] = "Du har ikke tilgang på denne ansatte"
            redirect_to action: 'index', user_id: nil
          end
        end
      end
    end
  end
  
 def approve_all

    unless current_user.is_admin?
      if @user
        workdays = @user.workdays.where("MONTH(date) = ? AND YEAR(date) = ? AND group_id = ?",
        @date.month, @date.year, current_user.group_id)
      else
        workdays = Workday.where("MONTH(date) = ? AND YEAR(date) = ? AND group_id = ?",
        @date.month, @date.year, current_user.group_id)
      end
    else
      if @user
        workdays = @user.workdays.where("MONTH(date) = ? AND YEAR(date) = ?",
      @date.month, @date.year)
      else
        workdays = Workday.where("MONTH(date) = ? AND YEAR(date) = ?",
      @date.month, @date.year)
      end
    end
      workdays.each do |workday|
        if workday.approved == nil && workday.user != current_user || current_user.is_admin?
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

  
  
  #Index action, GET /user/:user_id/workdays
  def index  
    
    @workdays = Workday.new.get_workdays_by_month(@user, @date, current_user)
    
    @workday = @workdays.map {|workday| workday[:day]}
    
    workdays_graph = Workday.new.get_workdays_by_month_user(@user, @date)
    
    @start = workdays_graph[:start]
    @stop = workdays_graph[:stop]
    

    respond_to do |format|
      format.html do 
        @workdays = Workday.new.get_workdays_by_month(@user, @date, current_user)
      end
      format.js 
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
    rescue ActiveRecord::RecordNotFound
        redirect_to action: 'index', user_id: nil
        return
  end
  
  #GET /users/:user_id/workdays/new
  def new
    @workday = Workday.new
  end

  #POST /users/:user_id/workdays
  def create
    
    
    comment = params[:workday][:comment]
    hours = params[:workday][:supervisor_hour].to_i
    date = params[:workday][:date]
    unless date.empty?
      new_date = try_date(date, @user.id)
    end
    
    @workday = Workday.new(date: date, comment: comment, supervisor_hour: hours, user_id: @user.id, approved: true)
   
    if @workday.save
       Workhour.create(count: hours*3600, start: Date.today.beginning_of_day,
     stop: Date.today.beginning_of_day + hours.hour, workday_id: @workday.id, user_id: @user.id)
      
      redirect_to action: 'show', id: @workday     
    else
      
      if hours == 0
        flash[:notice] = "Du må skrive inn antall timer.."
        render 'new'
        return
      end
      if hours > 24
        flash[:notice] = "Du kan ikke legge til mer en 24 timer for en dag, prøv å fordele over flere dager."
        render 'new'
        return
      end  
      if date.empty?
        flash[:notice] = "Du må velge en dato.."
        render 'new'       
      else
        flash[:notice] = "Datoen har allerede en registrert arbeidsdag, prøv:  #{new_date}"
        render 'new'
      end
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

      #du ender opp her om man delvis godkjenner
      else if params[:workday] 
        hours = params[:workday][:supervisor_hour].to_i
        if @workday.update_attributes(comment: params[:workday][:comment], approved: true, supervisor_hour: hours)
        
        else
        if hours > 24
        flash[:notice] = "Du kan ikke legge til mer en 24 timer for en dag, prøv å fordele over flere dager."
        redirect_to action: 'index', user_id: nil
        return
      end  
      
        end
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
