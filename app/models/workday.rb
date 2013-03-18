# == Schema Information
#
# Table name: workdays
#
#  id              :integer          not null, primary key
#  date            :date
#  user_id         :integer
#  comment         :string(255)
#  supervisor_hour :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  approved        :boolean          default(FALSE)
#

class Workday < ActiveRecord::Base
  attr_accessible :approved, :comment, :date, :supervisor_hour, :user_id
  has_many :workhours
  belongs_to :user
  validates :date, :uniqueness => {:scope => :user_id}

  
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
  
  def get_workdays_by_month(user_id, date)
      month = date.month
      year = date.year
     if user_id
      days = Workday.includes(:workhours).where("MONTH(date) = ? AND YEAR(date) = ? AND user_id = ?",
                                  month, year, user_id).order("date desc")
    else  
      days = Workday.includes(:workhours).where("MONTH(date) = ? AND YEAR(date) =?",month, year).order("date desc")
    end
    array = []
    days.each do |day|
      sum = get_workhour_sum(day.date, day.user.id)
      array.push({day: day, sum: sum})
    end
    return array
  end
  
  
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
