#encoding: utf-8
class RegisterController < ApplicationController

  def index
  end
  
  # Metode for å starte eller stoppe timeregistrering
  def register
      @message = ""
      # Sjekker om det er parameter fra automatisk registrering
      if params[:value] != nil
        # Henter ut bare tallene
        @value = params[:value].gsub(/[^0-9]/, '')
        # Leter etter et kort med angitt verdi
        @card = Card.where(card_value: @value).first
        # Hvis det eksisterer et kort, så registreres det start eller stop
        if @card != nil
          @message = Workhour.new.register(@card.user_id)
        # Hvis ikke blir man sendt til nettside for å registrere nytt
        else
          render :action => 'card_register' and return
        end
      end
      # Sjekker om det er parameter fra manuell registrering
      if params[:user_session] != nil
        # Hvis brukeren eksisterer startes/stoppes registrering
        session = params[:user_session]
        user = User.where(email: session[:email], pin: session[:password]).first
        unless user.nil?
          @message = Workhour.new.register(user.id)
        # Hvis ikke returneres feilmelding
        else
          @message = "Ukjent bruker"
          render :action => 'manual_register' and return
        end
      end
      render :action => 'index'
  end
  
  # Metode for å legge til kort
  def add_card
    # Sjekker om input er OK
    if params[:pin] != nil
      pin = params[:pin]
      card_id = params[:value]
      @message = Card.new.check_card_value(card_id, pin)
      render :action => 'index'
    # Hvis ikke returneres feilmelding
    else
      @message = "Du må fylle inn din PIN for å registrere kortet"
      render :action => 'card_register' and return
    end
  end

end
