#encoding: utf-8

class WorkdaysController < ApplicationController
  filter_resource_access
  respond_to :html, :json, :js
  
  before_filter :get_user, except: :check_group
  
  before_filter :check_group, only: [:index, :new, :edit]
  include DateModul
  before_filter :pager
  
  #henter en bruker om params[:user_id] finnes
  def get_user
     @user = User.includes(:workdays).find(params[:user_id]) if params[:user_id]
  end

#Sjekker at man er formann for rett avdeling
 def check_group
   #Er man admin har man tilgang til alt.
    unless current_user.is_admin?
      #sjekker om man er på siden /workdays eller /users/:user_id/workdays
      if params[:user_id]
        #ser om det er rett avdeling, hvis ikke blir man returnert til /workdays
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
  
 #Går gjennom alle ansatte som formann 
 #ikke har prosesert og godkjenner dem.
 def approve_all

    #Sjekker om man er admin
    unless current_user.is_admin?
      #Henter ut arbeidsdager basert på dato, gruppe id.
      if @user
        workdays = @user.workdays.where("MONTH(date) = ? AND YEAR(date) = ? AND group_id = ?",
        @date.month, @date.year, current_user.group_id)
      #Henter ut brukers arbeidsdager basert på dato, gruppe id.  
      else
        workdays = Workday.where("MONTH(date) = ? AND YEAR(date) = ? AND group_id = ?",
        @date.month, @date.year, current_user.group_id)
      end
    else
      #henter ut brukers arbeidsdager basert på dato.
      if @user
        workdays = @user.workdays.where("MONTH(date) = ? AND YEAR(date) = ?",
      @date.month, @date.year)
      #Henter ut arbeidsdager basert på dato.
      else
        workdays = Workday.where("MONTH(date) = ? AND YEAR(date) = ?",
      @date.month, @date.year)
      end
    end
    
    #Går gjennom alle arbeidsdagene, sjekker om man har rettigheter og
    #om dagen var i fortiden. Godkjenner så arbeidsdagene.
      workdays.each do |workday|
        if workday.approved == nil && workday.user != current_user && 
          Date.today.beginning_of_day > workday.date.beginning_of_day  || 
          current_user.is_admin? && Date.today.beginning_of_day > workday.date.beginning_of_day
          workday.update_attributes(approved: true)
        end
      end
    respond_with do |format|
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
    #Arbeidstimer for aktuell måned.
    @workdays = Workday.new.get_workdays_by_month(@user, @date, current_user)
    @workday = @workdays.map {|workday| workday[:day]}
    
    #Klargjør statistikk grafen.
    workdays_graph = Workday.new.populate_graph(@user, @date)    
    @start = workdays_graph[:start]
    @stop = workdays_graph[:stop]
    
    respond_with do |format|
      format.json {render json: Workday.includes(:workhours).all}
    end
    
  end

  #GET /users/:user_id/workdays/:id
  #Brukes kun som en del av apiet.
  def show
    
    if @user
        @workday = @user.workdays.find(params[:id]) 
    else     
        @workday = Workday.find(params[:id]) 
        @user = @workday.user
    end
    respond_with do |format|
      format.json {render json: @workday}
    end
    
  end
  
  #GET /users/:user_id/workdays/new
  def new
    @workday = Workday.new
  end

  #POST /users/:user_id/workdays
  def create
    
    #Henter ut variabler.
    comment = params[:workday][:comment]
    hours = params[:workday][:supervisor_hour].to_i
    date = params[:workday][:date]
    
    unless date.empty?
      new_date = try_date(date.to_s, @user.id)
    end
    
    
    @workday = Workday.new(date: date, comment: comment, supervisor_hour: hours, user_id: @user.id, approved: true)
   
    #Prøver å lagre workday, med en workhour.
    if @workday.save
       Workhour.create(count: hours*3600, start: Date.parse(date).beginning_of_day,
     stop: Date.parse(date).beginning_of_day + hours.hour, workday_id: @workday.id, user_id: @user.id)
      
      redirect_to user_path(@user)   
    else
      #Sjekker om man har skrevet inn timeantall
      if hours == 0
        flash[:notice] = "Du må skrive inn antall timer.."
        render 'new'
        return
      end
      #Sjekker om timeantall er større enn 24
      if hours > 24
        flash[:notice] = "Du kan ikke legge til mer en 24 timer for en dag, prøv å fordele over flere dager."
        render 'new'
        return
      end  
      #Sjekker om man har valgt en dato.
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
      #Henter arbeidsdag
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
        #Sjekker om timeantall er større enn 24
        if hours > 24
        flash[:notice] = "Du kan ikke legge til mer en 24 timer for en dag, prøv å fordele over flere dager."
        redirect_to action: 'index', user_id: nil
        return
      end  
      
        end
    end
    end
    
      respond_with do |format|
        format.html do
            redirect_to action: "index", user_id: nil
        end
      format.js 
      format.json {render json: @workday.to_json(only: :approved)}
    end
  end
end
