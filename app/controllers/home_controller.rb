class HomeController < ApplicationController


  def index
  end
  
  def automatic_register
      @message = ""
      if params[:value] != nil
        @value = params[:value].gsub(/[^0-9]/, '')
        @card = Card.where(card_value: @value).first
        
        if @card != nil
          row = @card.user.workhours.where(stop: nil).last
          if row != nil
            row.stop = Time.now
            row.count = (row.stop - row.start).to_i
            row.save
            @message = "Vellykket registrering: stoppet"
          else
            Workhour.create(start: Time.now, user_id: @card.user_id)
            @message = "Vellykket registrering: startet"
          end
        else
          render :action => 'unknown'
        end
      end
      render :action => 'index'
  end
  
  def manual_register
    @message = params[:id]
  end
  
end
