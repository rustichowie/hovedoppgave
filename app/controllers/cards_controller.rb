#encoding: utf-8

class CardsController < ApplicationController
  
  filter_resource_access
  
  respond_to :html, :json
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
  #GET /cards.json
  def index
    @cards = Card.all
    @user = Card.new.lookup(params[:id])
    respond_with(@cards)
  end

  # GET /cards/1
  # GET /cards/1.json
  def show
    @user = Card.new.lookup(params[:id])
    
    if @card
      respond_with(@card)
    else
      respond_with({error: "Ingen kort funnet", status: 404})
    end

  end

  # DELETE /cards/1
  def destroy
    @user = User.find(@card.user_id)
    @card.destroy

    respond_to do |format|
      format.html { redirect_to(@user) }
    end
  end
  
end
