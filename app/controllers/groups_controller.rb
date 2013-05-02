class GroupsController < ApplicationController
filter_resource_access
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
    respond_with(@group)
  end

  # GET /groups/new
  # GET /groups/new.xml
  def new
    @group = Group.new
  end

  # GET /groups/1/edit
  def edit
    @group = Group.find(params[:id])
  end

  # POST /groups
  # POST /groups.xml
  def create
    @group = Group.new(params[:group])

    respond_to do |format|
      if @group.save
        format.html { redirect_to(groups_path, :notice => 'Avdeling opprettet') }
        format.xml { render :xml => @group, :status => :created, :location => @group }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /groups/1
  # PUT /groups/1.xml
  def update
    @group = Group.find(params[:id])
    
    respond_to do |format|
      if @group.update_attributes(params[:group])
        format.html { redirect_to(groups_path, :notice => 'Group was successfully updated.') }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml { render :xml => @group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /cards/1
  # DELETE /cards/1.xml
  def destroy
    @group = Group.find(params[:id])
    @group.destroy

    respond_to do |format|
      format.html { redirect_to(groups_url) }
      format.xml { head :ok }
    end
  end
  
end
