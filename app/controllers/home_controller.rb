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

end
