# == Schema Information
#
# Table name: logs
#
#  id               :integer          not null, primary key
#  user_id          :integer
#  card_id          :integer
#  logtype_id       :integer
#  workhours_id     :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  workday_id       :integer
#  effected_user_id :integer
#

#Se workdays_controller for eksempel på lagring av log. og se metoden humanize for å se
#om du skal legge actions i en egen tabell.
class Log < ActiveRecord::Base
  attr_accessible :card_id, :int, :logtype_id, :user_id, :workhours_id, :action, :workday_id, :effected_user_id
  belongs_to :logtype 
  belongs_to :user
  belongs_to :workhour
  belongs_to :workday
  belongs_to :card
  

  #lager et array av den informasjonen jeg trenger: log beskjed, dato og bruker.
  def print_log(logtype_id, search, from, to)
    
    user_res = []
    action_res = []
    temp_logs = []
    date_res = []    
    unless search == nil  
      user_res = User.select(:id).where("name like ?", "%#{search}%")
      action_res = Log.where("action like ?", "%#{search}%")
    end
    #Filtrerer etter kategori.
    unless logtype_id == nil
      unless from == nil || to == nil        
      logs = Log.includes(:user, :workday, :workhour, :logtype, :card).where("logtype_id = ? and Date(created_at) >= ? AND Date(created_at) <= ?" ,logtype_id, from, to).order('created_at desc') 
      else
      logs = Log.includes(:user, :workday, :workhour, :logtype, :card).where(logtype_id: logtype_id).order('created_at desc')
      end
    else
      unless from == nil || to == nil  
      logs = Log.includes(:user, :workday, :workhour, :logtype, :card).where("Date(created_at) >= ? AND Date(created_at) <= ?" ,from, to).order('created_at desc')
      else
        logs = Log.includes(:user, :workday, :workhour, :logtype, :card).order('created_at desc')
      end
    end

      user_ids = user_res.map {|user| user.id}
      action_ids = action_res.map {|log| log.action}
      user_filtered_logs = logs.find_all_by_user_id(user_ids)
      eff_user_filtered_logs = logs.find_all_by_effected_user_id(user_ids)
      action_filtered_logs = logs.find_all_by_action(action_ids)
      temp_logs = eff_user_filtered_logs
      
      eff_user_filtered_logs.each do |eff|
        user_filtered_logs.each do |u|
          if eff.id == u.id
            temp_logs.delete(eff)
          end
        end
      end
      user_filtered_logs += temp_logs
      temp_logs = action_filtered_logs  
      
        
        action_filtered_logs.each do |a|
        user_filtered_logs.each do |u|
          unless a.id == u.id
            temp_logs.delete(a)
          end
        end
      end
      user_filtered_logs += temp_logs
      temp_logs = []
      
      unless search == nil
        logs = user_filtered_logs
      end
    
    
    printable_logs = []
    #Går gjennom alle log innlegg, lager egendefinert hash.
    #TODO: Hente de n siste logg innlegg?
    unless logs == nil
    logs.each do |log|
      message = humanize(log)     
      printable_logs.push({log: log, message: message})
      
    end
    end
    return printable_logs
  end
  

 #Lang metode, men med ganske enkel struktur. 
 #Henter informasjon fra loggen og lager en beskjed basert på to ting:
 #Hvilken logtype det er og hvilken action.
 #Action separerer hva som skjer innenfor en kategori.
 #Actions: start, stop, user, card, workday, in, out, approved, unapproved. 
 #TODO: (Mulig legge dette i en tabell...)
 #TODO: Formatere ferdig alle logbeskjedene.
 def humanize(log)

      if log.logtype.id.eql?(Logtype.find(1).id)
        if log.action.eql?("start")
          return "Registrerte start arbeidsdag"
        else
          return "Registrerte stop arbeidsdag"
        end
      end
      if log.logtype.id.eql?(Logtype.find(2).id)
        if log.action.eql?("user")
          return "Opprettet bruker: <strong>" + User.find(log.effected_user_id).name + "</strong>"
        end
        if log.action.eql?("card")
          return "Opprettet kort: " + log.card.card_value
        end
        if log.action.eql?("workday")
          return "Opprettet arbeidsdag til bruker: <strong>" + User.find(log.effected_user_id).name + "</strong>"
        end
      end
      if log.logtype.id.eql?(Logtype.find(3).id)
        if log.action.eql?("user")
          return "Slettet bruker: " + User.find(log.effected_user_id).name
        end
        if log.action.eql?("card")
          return "Slettet kort: " + log.card.card_value
        end
      end
      if log.logtype.id.eql?(Logtype.find(4).id)
        if log.action.eql?("user")
          return "Redigerte bruker: " + User.find(log.effected_user_id).name
        end
        if log.action.eql?("card")
          return "Redigerte kort: " + log.card.card_value
        end
        if log.action.eql?("workday")
          return "Redigerte arbeidsdagen med dato #{log.workday.date} til bruker: + #{User.find(log.effected_user_id).name}"
        end
      end
      if log.logtype.id.eql?(Logtype.find(5).id)
        if log.action.eql?("in")
          return "Logget inn"
        else
          return "Logget ut"
        end
      end
      if log.logtype.id.eql?(Logtype.find(6).id)
        if log.action.eql?("approved")
          return "Godkjente timer med dato #{log.workday.date} til bruker <strong> #{User.find(log.effected_user_id).name} </strong>"
        else
          return "Underkjente timer med dato #{log.workday.date} til bruker #{User.find(log.effected_user_id).name}"
        end
      end
      return nil
    end

end
