#encoding: utf-8
# == Schema Information
#
# Table name: cards
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  card_value :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Card < ActiveRecord::Base
  
  attr_accessible :card_value, :user_id
  belongs_to :user
  validates :card_value, :presence => true, :uniqueness => {:scope => :user_id}
  validates :user_id, :presence => true
  after_create do
    create_log
  end
  
  
  
  def create_log
    unless UserSession.find == nil
      Log.create(user_id: self.user.id, message: "#{self.user.name} har registrert et nytt kort på seg selv.", logtype_id: 2)
    end
  end
  
  
  # Metode for å registrere et kort på en bruker
  def check_card_value(value, pin)
    user = User.where(pin: pin).first
    # Sjekker om forige linje som sjekket etter 
    # brukere med anngitt PIN returnerte noe
    if user
      # Sjekker om verdien for hvilket kort det gjelder ikke er null
      if value  
        card = Card.where(user_id: user.id).first
        # Sjekker om linjen over, som leter etter et kort 
        # med den angitte brukeren returnerte en bruker
        if card
          # Hvis den gjorde det, gir beskjed om at det eksisterer et kort på brukeren
          respons = "Bruker allerede registrert med et kort"
        else
          # Hvis ikke opprettes et kort på den gitte brukeren
          Card.create(user_id: user.id, card_value: value)
          respons = "Kort registrert på: " + user.name
        end
        return respons
      else
        # Hvis det ikke er noen kortverdi med, er noe gådt galt
        return "Noe gikk galt"
      end
    else
      # Hvis det ikke finnes en bruker med den angitte PIN
      return "Finner ingen bruker med denne PIN"
    end  
  end
  
  def lookup(id)
    user = nil
    cards = Card.all
    cards.each do |card|
      card_value = card.card_value
      val = card_value.slice(7,13)
      unless id.nil?
        if id.include?(val)
          user = User.find(card.user_id)
        end
      end
    end
    return user
  end
end
