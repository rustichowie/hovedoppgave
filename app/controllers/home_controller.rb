class HomeController < ApplicationController


  def index
  end
  
  def automatic_register
      @message = ""
      if params[:value] != nil
        @message = "Suksess!"
      end
      #redirect_to('/', :notice => "Success")
      #flash[:notice] = "Success!".html_safe
      card = Card.new(user_id: 13, card_value: "card")
      card.check_card_value(card.card_value)
      render :action => 'index'
  end
  
  def manual_register
    @message = params[:id]
  end
  
end
