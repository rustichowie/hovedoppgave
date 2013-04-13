
# encoding: utf-8
class UsersController < ApplicationController 
  filter_resource_access

  #access_control do
    #allow all, :to => [:edit, :update, :delete], :if => :me?
    #allow all, :to => [:index]
    #allow :admin
    #allow logged_in, :to => [:show, :new, :create]
  #end
  include DateModul
  before_filter :pager
  

  # GET /users
  # GET /users.xml
  def index
    @users = User.where(active: true)

    respond_to do |format|
      format.html # index.html.haml
      format.xml { render :xml => @users }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])
    @workdays = Workday.new.get_workdays_by_month(@user, @date, current_user.group_id)
    @workdays_graph = Workday.new.get_workdays_by_month_user(@user, @date)
    
    @card = Card.where(user_id: params[:id]).first
    
    @start = Array.new
    @stop = Array.new
    @workdays_graph.each do |workday|
      
      forlat = Array.new
      workhours = Workhour.where(workday_id: workday.id)
      unless workhours.empty?
      

        latest = 0
        time = 0
        workhours.each do |workhour|
          if workhour.stop.to_time.to_i > latest
            latest = workhour.stop.to_time.to_i
            time = workhour.stop
          end
        end
        forlat.push(workday.date.to_time.to_i*1000)
        forlat.push(time.strftime("%H%M").to_i)
        @stop.push(forlat.to_json.html_safe)
      
        ankomst = Array.new
        #ankomst.push(workday.created_at.strftime("%F").to_i)
        ankomst.push(workday.date.to_time.to_i*1000)#date.strftime("%Y/%m/%d"))
        ankomst.push(workday.created_at.strftime("%H%M").to_i)#.strftime("%H:%M").to_time.to_i)
      
        @start.push(ankomst.to_json.html_safe)
      
      end
     end
    respond_to do |format|
      format.html 
      format.js
      format.xml { render :xml => @user }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new
    @groups = Group.all
    @roles = Role.all
    respond_to do |format|
      format.html # new.html.haml
      format.xml { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
    @groups = Group.all
    @roles = Role.all
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])
    @groups = Group.all
    @roles = Role.all
    respond_to do |format|
      if @user.save
        format.html { redirect_to(@user, :notice => 'User was successfully created.') }
        format.xml { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to(@user, :notice => 'User was successfully updated.') }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.active = false
    @user.save

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml { head :ok }
    end
  end
  
end