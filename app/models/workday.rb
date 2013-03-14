# == Schema Information
#
# Table name: workdays
#
#  id              :integer          not null, primary key
#  date            :datetime
#  user_id         :integer
#  comment         :string(255)
#  supervisor_hour :integer
#  approved        :boolean
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Workday < ActiveRecord::Base
  attr_accessible :approved, :comment, :date, :supervisor_hour, :user_id
  has_many :workhours
  belongs_to :user
  
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
