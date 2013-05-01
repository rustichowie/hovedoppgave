#encoding: utf-8
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
#TODO: Sjekke at det logges overalt. ordne på 
class Workday < ActiveRecord::Base
  attr_accessible :approved, :comment, :date, :supervisor_hour, :user_id
  has_many :workhours
  belongs_to :user
  validates :date, :uniqueness => {:scope => :user_id}
  validates :date, :presence => true
  validates :supervisor_hour,:numericality => {:less_than => 24}, :allow_nil => true
  
  after_create do
    create_log(self.user)
  end
  after_update do
    update_log(self.user, self.approved)
  end
  
  def create_log(user)
    unless UserSession.find == nil
    Log.create(user_id: user.id, message: "#{UserSession.find.user.name} har opprettet en arbeidsdag for #{user.name} den #{self.date}", logtype_id: 2)
    else
      Log.create(user_id: user.id, message: "#{user.name} har opprettet en ny arbeidsdag på seg selv den #{self.date}", logtype_id: 2)
    end
  end
  
  def update_log(user, approved)
    unless approved == nil
      unless UserSession.find == nil
        if approved
          Log.create(user_id: user.id, message: "#{UserSession.find.user.name} har gokjent en arbeidsdag for #{user.name} den #{self.date}", logtype_id: 4)
        else
          Log.create(user_id: user.id, message: "#{UserSession.find.user.name} har underkjent en arbeidsdag for #{user.name} den #{self.date}", logtype_id: 4)
        end
      end
    end
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
  def get_workdays_by_month(user_id, date, current_user)
      #henter ut måned og år fra datoen
      month = date.month
      year = date.year
      #hvis man sender inn en bruker id sjekker han får dette, ellers ikke.
     if user_id
      days = Workday.includes(:workhours).where("MONTH(date) = ? AND YEAR(date) = ? AND user_id = ?",
                                  month, year, user_id).order("date desc")
    else  
      if current_user.is_admin?
      days = Workday.includes(:workhours).where("MONTH(date) = ? AND YEAR(date) = ?",
                                  month, year).order("date desc")
      else
       days = Workday.includes(:workhours).where("MONTH(date) = ? AND YEAR(date) = ? AND user_id != ?",
                                  month, year, current_user.id).order("date desc") 
      end
    end
    new_days = []
     unless current_user.is_admin?
      unless days.empty?
        days.each do |day|
          if day.user.group_id == current_user.group_id
            new_days.push(day)
          end
        end
        days = new_days
      end
    end
    array = []
    #Går igjennom alle dagene og legger rett sum til rett dag.
    days.each do |day|
      #bruker timene supervisor har lagt inn som default
      if day.supervisor_hour
        sum = humanize_workhours(day.supervisor_hour*1.hour)
      else
        sum = get_workhour_sum(day.date, day.user.id)
      end
      #pusher en hash til arrayet
      array.push({day: day, sum: sum})
    end
    return array
  end
  
  
  #Henter workdays basert på måned og bruker id.
  def get_workdays_by_month_user(user_id, date)
    #henter ut måned og år fra datoen
    month = date.month
    year = date.year
    days = Workday.includes(:workhours).where("MONTH(date) = ? AND YEAR(date) = ? AND user_id = ? AND approved = ? AND supervisor_hour is null",
                                  month, year, user_id, 1).order("date desc")

    start = Array.new
    stop = Array.new
    days.each do |workday|
      
      workhours = Workhour.where(workday_id: workday.id)
      unless workhours.empty?
        latest = 0
        time = 0
        workhours.each do |workhour|
          unless workhour.stop == nil

          if workhour.stop.to_time.to_i > latest
            latest = workhour.stop.to_time.to_i
            time = workhour.stop

          end
          end
        end
        forlat = Array.new
        forlat.push(workday.date.to_time.to_i*1000)
        forlat.push(time.strftime("%H%M").to_i)
        stop.push(forlat.to_json.html_safe)
      
        ankomst = Array.new
        #ankomst.push(workday.created_at.strftime("%F").to_i)
        ankomst.push(workday.date.to_time.to_i*1000)#date.strftime("%Y/%m/%d"))
        ankomst.push(workday.created_at.strftime("%H%M").to_i)#.strftime("%H:%M").to_time.to_i)
        start.push(ankomst.to_json.html_safe)
      
      end
     end
     
    return {start: start, stop: stop}
  end
  
  #Henter summen av arbeidstimer basert på bruker og dato
  def get_workhour_sum(date, user_id)
    sum = Workhour.sum(:count, conditions: ["DATE(start) = ? AND user_id = ?", date, user_id])
    return humanize_workhours(sum)  
  end

  def humanize_workhours(sum)
    final_sum = ((sum/3600.0)*4).round / 4.0
    hours = final_sum.round
    minutes = ((final_sum-hours)*1.minute).round
    if hours == 0
      if minutes != 0
        return "#{minutes} minutter."       
      else
        return "For liten tidsperiode (mindre enn 15 minutt)"   
      end
    else
      if minutes != 0
        return "#{hours} timer og #{minutes} minutter."
      else
        return "#{hours} timer."
      end
    end
    
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





