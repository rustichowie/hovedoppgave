
# encoding: utf-8
class UsersController < ApplicationController 
  filter_resource_access

  respond_to :html, :json, :js
  include DateModul
  before_filter :pager
  

  # GET /users
  # GET /users.json
  def index
    @users = User.where(active: true)

    respond_with(@users)
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find(params[:id])

    @workdays = Workday.new.get_workdays_by_month(@user, @date, current_user)

    @card = Card.where(user_id: params[:id]).first
    
    workdays_graph = Workday.new.populate_graph(@user, @date)
    @start = workdays_graph[:start]
    @stop = workdays_graph[:stop]
    if @user
      respond_with(@user)
    else
      respond_with({error: "Ingen ansatt funnet", status: 404})
    end

  end

  # GET /users/new
  def new
    @user = User.new
    @groups = Group.all
    @roles = Role.all
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
    @groups = Group.all
    @roles = Role.all
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(params[:user])
    @user.pin = User.new.generate_pin
    @groups = Group.all
    @roles = Role.all
    respond_with do |format|
      if @user.save
        format.html { redirect_to(@user, :notice => 'User was successfully created.') }
        format.json { render json: @user }
      else
        format.html { render :action => "new" }
        format.json { render json: {error: @user.errors} }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @groups = Group.all
    @roles = Role.all
    @user = User.find(params[:id])
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to(@user, :notice => 'User was successfully updated.') }
        format.json { render json: @user}
      else
        format.html { render :action => "edit" }
        format.json { render json: {error: @user.errors}}
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])
    @user.active = false
    @user.save

    respond_with do |format|
      format.html { redirect_to(users_url) }
      format.json { render json: @user }
    end
  end
  
  # metode som registrerer nye brukere fra ekstern database
  def create_import
    users = RemoteUser.new.import
    users.each do |us|
      u = User.new(name: us["navn"], group_id: 1, role_id: 1, password: "passord", password_confirmation: "passord")
      u.pin = User.new.generate_pin
      unless us["tel"] == ""
        u.phone_number = us["tel"].gsub(/[^0-9]/, '') #formaterer bort alt annet en nummer
      end
      unless us["epost"] == ""
        u.epost = us["epost"]
      end
      u.save
    end
    
    respond_with do |format|
      format.html { redirect_to(users_path) }
    end
  end
  
end