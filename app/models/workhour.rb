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
