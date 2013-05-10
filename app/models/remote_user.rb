class Remote_user < ActiveRecord::Base

  establish_connection "hlonn_database"
  
  after_create do
    create_log
  end
  
  def create_log
    unless UserSession.find == nil
    Log.create(user_id: self.id, message: "#{UserSession.find.user.name} har opprettet en ny ansatt med navn: #{self.name} den #{self.created_at.strftime("%Y-%m-%d")}", logtype_id: 2)
    else
      Log.create(user_id: user.id, message: "#{self.name} har blitt opprettet den #{self.created_at.strftime("%Y-%m-%d")}", logtype_id: 2)
    end
  end 
  
  #foreløbig metode for å hente ut bruker(e)
  def get(index)
    query = "select * FROM Operator"
    tst = connection.select_all(query) #select_all is important!
    unless index.nil?
      return tst[index].fetch()
    else
      return tst[0].fetch()
    end
  end
  
  #importere brukere fra HLonn database
  def import
    ids = []
    query = "select * FROM Operator" #henter ut alle fra Operator
    tst = connection.select_all(query) #select_all is important!
    tst.each do |result| #Fyller et array med relevant info, senere skal det ikke trenges å lage nytt array, men å hente ut akkurat det man vil ha rett fra spørringen
      ids.push(result.fetch('OperatorID'))
    end
    usrs = User.all
    #Går gjennom alle brukerne for hver bruker hos HLonn, og sjekker om de allerede er importert, hvis ikke importeres de.
    ids.each do |remote|
      exist = false #bool som holder på verdien om de eksisterer eller ikke
      usrs.each do |user|
        if remote == user.remote_id
          exist = true #forandrer verdien når de er funnet blandt de som allerede er importert
        end
      end
      unless exist #Hvis brukeren ikke eksisterte fra før, lages det en ny bruker
        addRemoteUser()
      end
    end
  end
  
  # Metoden som oppretter en ny bruker
  def addRemoteUser
    return yolo
  end

end