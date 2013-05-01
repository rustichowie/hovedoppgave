#encoding: utf-8

module PinProvider
  
  def run_casper(num, pin)
    t = Thread.new do 
    text_message = "Pinkode for å registrere kort: #{pin}"
    system "casperjs test app/assets/javascripts/sms.js --num='#{num}' --text='#{text_message}'"
    end
    t.kill
  end
end