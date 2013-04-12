# == Schema Information
#
# Table name: workdays
#
#  id              :integer          not null, primary key
#  user_id         :integer          not null
#  comment         :string(255)
#  supervisor_hour :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  approved        :boolean
#  date            :date             not null
#

class Workday < ActiveRecord::Base
  attr_accessible :approved, :comment, :date, :supervisor_hour, :user_id
  has_many :workhours
  belongs_to :user
  has_many :logs
  validates :date, :uniqueness => {:scope => :user_id}

  def to_param
    "#{id}-#{user.name}"
  end
  #Henter ut arbeidsdager basert på bruker id.
  #Metoden sjekker om man sender inn nil eller en bruker id,
  #og basert på dette henter han henten dager for en bruker eller
  #alle dager i databasen.
  #@return array av en hash som inneholder dag listen, arbeidstimesummen, og aktuell måned.
  def get_workdays(user_id)
    if user_id
      days = Workday.includes(:workhours).where(user_id: user_id).order("date desc")
    else  
      days = Workday.includes(:workhours).order("date desc")
    end

    array = []  
    sum = nil
      days.each do |day|
        sum = get_workhour_sum(day.date, day.user.id)
          array.push({day: day, sum: sum})
      end    
    return array
  end
  
  #Henter jobbtimer basert på måned og bruker id.
  def get_workdays_by_month(user_id, date)
      #henter ut måned og år fra datoen
      month = date.month
      year = date.year
      #hvis man sender inn en bruker id sjekker han får dette, ellers ikke.
     if user_id
      days = Workday.includes(:workhours).where("MONTH(date) = ? AND YEAR(date) = ? AND user_id = ?",
                                  month, year, user_id).order("date desc")
    else  
      days = Workday.includes(:workhours).where("MONTH(date) = ? AND YEAR(date) =?",month, year).order("date desc")
    end
    
    array = []
    #Går igjennom alle dagene og legger rett sum til rett dag.
    days.each do |day|
      #bruker timene supervisor har lagt inn som default
      if day.supervisor_hour
        sum = supervisor_hour
      else
        sum = get_workhour_sum(day.date, day.user.id)
      end
      #pusher en hash til arrayet
      array.push({day: day, sum: sum})
    end
    return array
  end
  
  #Henter summen av arbeidstimer basert på bruker og dato
  def get_workhour_sum(date, user_id)
    return Workhour.sum(:count, conditions: ["DATE(start) = ? AND user_id = ?", date, user_id])
  end
  
  

  # Metode som sjekker om det eksisterer en arbeidsdag for brukeren i dag
  # hvis det eksisterer, returneres id, hvis ikke returneres false
  def check_for_workday_now(user_id)
    date = Date.today # Dagens dato
    day = Workday.where(user_id: user_id, date: date).first # Workday til brukeren
    if day
      return day.id
    else
      return false
    end
  end
end
