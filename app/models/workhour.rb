# == Schema Information
#
# Table name: workhours
#
#  id         :integer          not null, primary key
#  start      :datetime
#  stop       :datetime
#  user_id    :integer          not null
#  count      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  workday_id :integer          not null
#

class Workhour < ActiveRecord::Base
  attr_accessible :count, :start, :stop, :user_id, :workday_id
  belongs_to :user
  belongs_to :workday
  has_many :logs
  
  #Sjekker om en bruker har noen jobbtimer
  def has_workhours(user_id, n)
     user = User.find(user_id)
     workhour_day = user.workhours.where("DATE(start) = ?", n)
     unless workhour_day.empty?
       return false
     else
       return true
     end 
  end
    
  
  
  
  
  # Metode for å starte eller stoppe en arbeidsøkt på en bruker
  def register(user_id)
    # Sjekker om det er en workhour rad som ikke er stoppet
    workhour = Workhour.where(user_id: user_id, stop: nil).last
    # Finner ut om det eksisterer en workday for dagen
    workday = Workday.new.check_for_workday_now(user_id)
    # Hvis ikke lages en ny
    if workday == false
      day = Workday.create(date: Date.today, user_id: user_id)
      workday_id = day.id
    # Hvis det eksisterer, er det id som blir returnert av "check_for_workday_now" metoden over
    # og denne ID settes
    else
      workday_id = workday
    end
    # Hvis det eksisterer en åpen workhour, stoppes den
    if workhour != nil
      workhour.workday_id = workday_id
      workhour.stop = Time.now
      workhour.count = (workhour.stop - workhour.start).to_i
      workhour.save
      response = "Timeregistrering stoppet"
    # Hvis ikke, startes det en ny
    else
      Workhour.create(start: Time.now, user_id: user_id, workday_id: workday_id)
      response = "Timeregistrering startet"
    end
    return response
  end
end
