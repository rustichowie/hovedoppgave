module PinProvider
  
  def run_casper(num, pin)
    
    text_message = "Pinkode for å registrere kort: #{pin}"
    system "casperjs test app/assets/javascripts/sms.js --num='#{num}' --text='#{text_message}'"
  end
end