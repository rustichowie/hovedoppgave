class RemoteUser
  
  
  
  
  def database
    #passord må fylles inn etter push
    file = File.new("db_pwd", "r")
    pwd = file.read.chomp
    file.close
    return client = TinyTds::Client.new(:username => 'timereg', :password => "#{pwd}", :host => '192.168.44.4', :database => 'HLonn0004')
  end
  
  #foreløbig metode for å hente ut bruker(e)
  def get(index)
    query = "select * FROM Operator"
    tst = connection.select_all(query) #select_all is important!
    return tst[index].fetch()
  end
  
  #importere brukere fra HLonn database
  def import
    remote = []
    result = []
    import_array = []
    client = database()
    result = client.execute("SELECT * FROM Personer")
    result.each do |res|
      r = {"id" =>  res["PersonerID"], "navn" => res["Name"], "tel" => res["TelMobil"], "epost" => res["EPostAddresse"]}
      remote.push(r)
    end
    usrs = User.all
    #Går gjennom alle brukerne for hver bruker hos HLonn0004, og sjekker om de allerede er importert, hvis ikke importeres de.
    remote.each do |rem|
      exist = false #bool som holder på verdien om de eksisterer eller ikke
      usrs.each do |user|
        if rem["id"] == user.remote_id
          exist = true #forandrer verdien når de er funnet blandt de som allerede er importert
        end
      end
      unless exist #Hvis brukeren ikke eksisterte fra før, skal den returneres
        import_array.push(rem)
      end
    end
    return result
  end


end