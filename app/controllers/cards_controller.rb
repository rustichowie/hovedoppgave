class CardsController < ApplicationController
  
  before_filter :get_card, only: [:show, :edit, :destroy, :update]
  
  
  def get_card
    @card = Card.find(params[:id])
  end
  
  
  def index
    @cards = Card.all

    respond_to do |format|
      format.html # index.html.haml
      format.xml { render :xml => @cards }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    

    respond_to do |format|
      format.html # show.html.haml
      format.xml { render :xml => @card }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @card = User.new

    respond_to do |format|
      format.html # new.html.haml
      format.xml { render :xml => @card }
    end
  end

  # GET /users/1/edit
  def edit
    
  end

  # POST /users
  # POST /users.xml
  def create
    @card = User.new(params[:card])

    respond_to do |format|
      if @card.save
        format.html { redirect_to(@card, :notice => 'User was successfully created.') }
        format.xml { render :xml => @card, :status => :created, :location => @card }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @card.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    

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
    @card.destroy

    respond_to do |format|
      format.html { redirect_to(cards_url) }
      format.xml { head :ok }
    end
  end
  
end
