class CardsController < ApplicationController
  filter_resource_access
  before_filter :get_card, only: [:edit, :destroy, :update]
  before_filter :get_user
  #henter en bruker om params[:user_id] finnes
  def get_user
     @user = User.find(params[:user_id]) if params[:user_id]
  end
  #Henter et kort
  def get_card
    @card = Card.find(params[:id])
  end
  
  #GET /cards
  #GET /cards.xml
  def index
    @user = Card.new.lookup(params[:id])
    respond_to do |format|
      format.html # index.html.haml
      format.xml { render :xml => @cards }
    end
  end

  # GET /cards/1
  # GET /cards/1.xml
  def show
    @user = Card.new.lookup(params[:id])
    
    respond_to do |format|
      format.html # show.html.haml
      format.xml { render :xml => @card }
    end
  end

  # GET /cards/new
  # GET /cards/new.xml
  def new
    @card = Card.new
    @users = User.all
    respond_to do |format|
      format.html # new.html.haml
      format.xml { render :xml => @card }
    end
  end

  # GET /cards/1/edit
  def edit
    
  end

  # POST /cards
  # POST /cards.xml
  def create
    @card = Card.new(card_value: params[:card][:card_value], user_id: params[:user_id])

    respond_to do |format|
      if @card.save
        Log.create(user_id: current_user.id, logtype_id: 2, action: "card", card_id: @card.id)
        format.html { redirect_to(cards_path, :notice => 'User was successfully created.') }
        format.xml { render :xml => @card, :status => :created, :location => @card }
      else
        format.html { render :action => "new" }
        format.xml { render :xml => @card.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /cards/1
  # PUT /cards/1.xml
  def update

    respond_to do |format|
      if @card.update_attributes(params[:card])
        format.html { redirect_to(cards_path, :notice => 'User was successfully updated.') }
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /cards/1
  # DELETE /cards/1.xml
  def destroy
    @user = User.find(@card.user_id)
    @card.destroy

    respond_to do |format|
      format.html { redirect_to(@user) }
      format.xml { head :ok }
    end
  end
  
end
