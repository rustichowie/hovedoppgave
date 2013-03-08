# == Schema Information
#
# Table name: workhours
#
#  id              :integer          not null, primary key
#  start           :datetime
#  stop            :datetime
#  user_id         :integer          not null
#  count           :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  approved        :boolean
#  comment         :text
#  supervisor_hour :integer
#

class Workhour < ActiveRecord::Base
  attr_accessible :count, :start, :stop, :user_id
  belongs_to :user
  
  def has_workhours(user_id)
     @user = User.find(user_id)
     unless @user.workhours.empty?
       return false
     else
       return true
     end 
  end
  
  def group_workhours
    @count = (Workhour.order("DATE(start) desc").group("DATE(start)").count).keys
    @array = [] 
    @sum = nil
    @user = User.all
    @user.each do |u|
      
      @count.each do |n|
        unless has_workhours(u.id) == true
          child = Workhour.find(:all, conditions: ["DATE(start) = ? AND user_id = ?", n, u.id])
          sum = Workhour.sum(:count, conditions: ["DATE(start) = ? AND user_id = ?", n, u.id])
          @array.push({user: u, info: {day: n, hours: child, sum: sum}})
      end
      end
    end
    return @array
  end
  
  def register(user_id)
    workhour = Workhour.where(user_id: user_id, stop: nil).last
    if workhour != nil
      workhour.stop = Time.now
      workhour.count = (workhour.stop - workhour.start).to_i
      workhour.save
      response = "Vellykket registrering: stoppet"
    else
      Workhour.create(start: Time.now, user_id: user_id)
      response = "Vellykket registrering: startet"
    end
    return response
  end
end
