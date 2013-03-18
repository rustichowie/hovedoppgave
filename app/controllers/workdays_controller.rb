class WorkdaysController < ApplicationController
  
before_filter :get_user
  
  def get_user
     @user = User.includes(:workdays).find(params[:user_id]) if params[:user_id]
  end
  
  def index
       
       @prev_class = "enabled"
       @next_class = "enabled"
    
    if params[:date]
      @date = Date.parse(params[:date])
    else
      @date = Date.today 
    end
    respond_to do |format|
      format.html do
        #@workdays = Workday.new.get_workdays(params[:user_id])
          @workdays = Workday.new.get_workdays_by_month(params[:user_id], @date)
          
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
        #@workdays = Workday.new.get_workdays(params[:user_id])
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

  def show 
    @workday = @user.workdays.find(params[:id])
    @sum = @workday.get_workhour_sum(@workday.date, @user.id)
  end
  

  def new
    @workday = Workday.new
  end

  def create
    comment = params[:workday][:comment]
    hours = params[:workday][:supervisor_hour]
    @workday = Workday.new(date: Date.today, comment: comment, supervisor_hour: hours, user_id: @user.id)
    if @workday.save
      redirect_to action: 'show', id: @workday
    else
        render 'new'
    end
  end

  def edit
    
    
  end

  def update
      @workday = Workday.find(params[:id])
     if params[:approved] 
            @workday.update_attributes(approved: params[:approved])        

      else if params[:workday] 
        @workday.update_attributes(comment: params[:workday][:comment], approved: true, supervisor_hour: params[:workday][:supervisor_hour])
    end
    end
    #@workday.approved = true
      respond_to do |format|
        format.html do
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

  def destroy
  end
end
