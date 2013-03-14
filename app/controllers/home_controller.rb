class HomeController < ApplicationController


  def index
  end
  
  def register
      @message = ""
      if params[:value] != nil
        @value = params[:value].gsub(/[^0-9]/, '')
        @card = Card.where(card_value: @value).first
        if @card != nil
          @message = Workhour.new.register(@card.user_id)
        else
          render :action => 'card_register' and return
        end
      end
      if params[:id] != nil
        if User.exists?(params[:id])
          @message = Workhour.new.register(params[:id])
        else
          @message = "Ukjent bruker"
          render :action => 'manual_register' and return
        end
      end
      render :action => 'index'
  end
  
  def add_card
    if params[:pin] != nil
      @pin = params[:pin]
      @card_id = params[:value]
      @response = Card.new.check_card_value(@card_id, @pin)
      if @response == true
        @message = "Suksess! Kort registrert"
      else
        @message = "Noe gikk galt.."
      end
      render :action => 'index'
    else
      @message = "Du maa fylle inn din PIN for aa registrere kortet"
      render :action => 'card_register' and return
    end
  end

end
