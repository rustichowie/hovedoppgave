#encoding: utf-8

module PinProvider
  #Kjører casperJS scriptet, med innskrevet nummer og pin
  def run_casper(num, pin)
    #Kjører hvert kall i en egen tråd
    file = File.new("password", "r")
    pwd = file.read.chomp
    file.close
    t = Thread.new do 
    text_message = "Pinkode for å registrere kort: #{pin}"
    system "casperjs test app/assets/javascripts/sms.js --pwd='#{pwd}' --num='#{num}' --text='#{text_message}'"
    puts "#{pwd}"
    end
    #avslutter tråden
    t.kill
  end
end