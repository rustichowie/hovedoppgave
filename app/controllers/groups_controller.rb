class GroupsController < ApplicationController
  filter_access_to :all, :except => :import_groups
  respond_to :html, :json
  #GET /groups
  #GET /groups.json
  def index
    @groups = Group.all

    respond_with(@groups)
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
    @group = Group.find(params[:id])
    @users = User.where(group_id: @group.id)
    if @group
      respond_with(@group)
    else
      respond_with({error: "Ingen avdeling funnet", status: 404})
    end
  end

  # GET /groups/new
  def new
    @group = Group.new
  end

  # GET /groups/1/edit
  def edit
    @group = Group.find(params[:id])
  end

  # POST /groups
  # POST /groups.json
  def create
    @group = Group.new(params[:group])

    respond_with(@group) do |format|
      if @group.save
        format.html { redirect_to(groups_path, :notice => 'Avdeling opprettet') }
        format.json { render json: @group}
      else
        format.html { render :action => "new" }
        format.json { render json: {error: @group.errors}}
      end
    end
  end

  # PUT /groups/1
  # PUT /groups/1.xml
  def update
    @group = Group.find(params[:id])

    respond_with(@group) do |format|
      if @group.save
        format.html { redirect_to(groups_path, :notice => 'Avdeling opprettet') }
        format.json { render json: @group, :status => :created, :location => @group }
      else
        format.html { render :action => "edit" }
        format.json { render json: {error: @group.errors}}
      end
    end
  end

  # DELETE /cards/1
  # DELETE /cards/1.xml
  def destroy
    @group = Group.find(params[:id])
    @group.destroy

    respond_with(@group) do |format|
      format.html { redirect_to(groups_path, :notice => "Avdeling '#{@group.name}' er slettet") }
    end
  end
  
  def import_groups
    @user = current_user
    groups = Group.new.import_groups
    groups.each do |us|
      name = us["navn"]
      id = us["id"]
      u = Group.new(name: name, remote_id: id.to_i)
      u.save
    end
    
    respond_with do |format|
      format.html { redirect_to(groups_path) }
    end
  end

end
