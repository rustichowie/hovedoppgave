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


  def has_workdays(user_id, date)
     user = User.find(user_id)
     workdays = user.workdays.where("date = ?", date)
     unless workdays.empty?
       return false
     else
       return true
     end 
  end
  
  def get_workdays
    days = Workday.includes(:workhours).where(approved: false)
    array = [] 
    sum = nil
    user = User.all
    days.each do |day|    
          sum = Workhour.sum(:count, conditions: ["DATE(start) = ? AND user_id = ?", day.date, day.user.id])
          array.push({user: day.user, info: {day: day, sum: sum}})
    end
    array.sort_by
    return array
  end
  
  
  
  

  # Metode som sjekker om det eksisterer en arbeidsdag for brukeren i dag
  # hvis det eksisterer, returneres id, hvis ikke returneres false
  def check_for_workday_now(user_id)
    date = DateTime.now.to_date # Dagens dato
    day = Workday.where(user_id: user_id) # Alle workdays til brukeren
    workday = day.where("DATE(date) = ?",date).first # workday med dagens dato
    if workday
      return workday.id
    else
      return false
    end
  end
end
