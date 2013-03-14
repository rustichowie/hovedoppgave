# == Schema Information
#
# Table name: workdays
#
#  id              :integer          not null, primary key
#  date            :datetime
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
  

  def get_workhours(user_id, n)
     user = User.find(user_id)
     workhours = user.workhours.where("DATE(start) = ?", n).order("TIME(start) desc")
     return workhours
  end
  
  def get_workdays
    @days = Workday.where(approved: false)
    @array = [] 
    @sum = nil
    @user = User.all
    @days.each do |day|
    @user.each do |u| 
        unless get_workhours(u.id, day.date.to_date).empty?
          child = get_workhours(u.id, day.date.to_date)
          sum = Workhour.sum(:count, conditions: ["DATE(start) = ? AND user_id = ?", day, u.id])
          @array.push({user: u, info: {day: day, hours: child, sum: sum}})
      end
      end
    end
    return @array
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
