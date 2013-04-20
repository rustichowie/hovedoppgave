# == Schema Information
#
# Table name: logs
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  logtype_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
#Se workdays_controller for eksempel på lagring av log. og se metoden humanize for å se
#om du skal legge actions i en egen tabell.
class Log < ActiveRecord::Base
  attr_accessible :logtype_id, :user_id, :message
  belongs_to :logtype
  belongs_to :user
  #lager et array av den informasjonen jeg trenger: log beskjed, dato og bruker.
  def print_log(logtype_id, search, from, to)

    message_res = []

    unless search == nil
      message_res = Log.select(:message).where("message like ?", "%#{search}%")
    end
    #Filtrerer etter kategori.
    unless logtype_id == nil
      unless from == nil || to == nil
        logs = Log.includes(:user, :logtype).where("logtype_id = ? and Date(created_at) >= ? AND Date(created_at) <= ?" ,logtype_id, from, to).order('created_at desc')
      else
        logs = Log.includes(:user, :logtype).where(logtype_id: logtype_id).order('created_at desc')
      end
    else
      unless from == nil || to == nil
        logs = Log.includes(:user, :logtype).where("Date(created_at) >= ? AND Date(created_at) <= ?" ,from, to).order('created_at desc')
      else
        logs = Log.includes(:user, :logtype).order('created_at desc')
      end
    end

    message = message_res.map {|log| log.message}
    message_filtered_logs = logs.find_all_by_message(message)

    unless search == nil
    logs = message_filtered_logs
    end

    printable_logs = []

    unless logs == nil
    printable_logs = logs
    end
    return printable_logs
  end

end
