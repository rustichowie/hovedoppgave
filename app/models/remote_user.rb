class RemoteUser
  
  
  
  
  def database
    #passord må fylles inn etter push
    file = File.new("db_pwd", "r")
    pwd = file.read.chomp
    file.close
    return client = TinyTds::Client.new(:username => 'timereg', :password => "#{pwd}", :host => '192.168.44.4', :database => 'HLonn0004')
  end

  
  #importere brukere fra HLonn database
  def import
    remote = []
    result = []
    import_array = []
    client = database()
    result = client.execute("SELECT * FROM Personer")
    result.each do |res|
      name = Iconv.conv("UTF-8", "iso8859-1", res["Name"])
      surname = Iconv.conv("UTF-8", "iso8859-1", res["Surname"])
      name = name.downcase
      surname = surname.downcase
      r = {"id" =>  res["PersonerID"], "navn" => "#{name.humanize} #{surname.humanize}", "tel" => res["TelMobil"], "epost" => res["EPostAddresse"]}
      remote.push(r)
    end
    usrs = User.all
    #Går gjennom alle brukerne for hver bruker hos HLonn0004, og sjekker om de allerede er importert, hvis ikke importeres de.
    remote.each do |rem|
      exist = false #bool som holder på verdien om de eksisterer eller ikke
      usrs.each do |user|
        unless user.remote_id == nil
          if rem["id"] == user.remote_id
            exist = true #forandrer verdien når de er funnet blandt de som allerede er importert
          end
        end
      end
      unless exist #Hvis brukeren ikke eksisterte fra før, skal den returneres
        import_array.push(rem)
      end
    end
    return import_array
  end


end