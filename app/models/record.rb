#encoding: utf-8
# == Schema Information
#
# Table name: cards
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  card_value :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Record
  
  
  def database
    #passord må fylles inn etter push
    file = File.new("db_pwd", "r")
    pwd = file.read.chomp
    file.close
  
    return client = TinyTds::Client.new(:username => 'timereg', :password => "#{pwd}", :host => '192.168.44.4', :database => 'HLonn0004')
  end
  def write_record(workdays)
    client = database()
    position = 0
  
    
    
    satser = []
    satsRes = client.execute("SELECT * FROM PersonSatser where SatsValue is not null")
    satsRes.each do |res|
      r = {"id" => res["PersonerID"], "sats" => res["SatsValue"]*100}
      satser.push(r)
    end
    
    prosjekter = []
    prosjektRes = client.execute("SELECT * FROM PersonProjekt")
    prosjektRes.each do |res|
      r = {"prosjektId" => res["ProsjekterID"], "personId" => res["PersonerID"]}
      prosjekter.push(r)
    end
    
    #get lonnsartnr
    #get avdelingsnr
    #get element1-5
    if File.exists?("/tmp/IT0001TRS.HLW")
    File.delete('/tmp/IT0001TRS.HLW')
    end
    unless workdays.empty?
    workdays.each do |workday|
      user = User.find(workday.user_id)
      if workday.supervisor_hour.nil?
        antallKalk = workday.workhours_sum(workday.date, workday.id)
      else
        antallKalk = workday.supervisor_hour
      end
      
      #Sats
      sats = "0000000000"
      satsKalk = 0
      satser.each do |sat|
        if user.remote_id != nil
        if user.remote_id == sat["id"].to_s
          sats = "%010d" % sat["sats"]
          satsKalk = sat["sats"]
        end
        end
      end
      
      #ProsjektNr
      prosjektNr = "000000000000"
      prosjekter.each do |pro|
        if user.remote_id == pro["personId"].to_s
          prosjektNr = "%012d" % pro["prosjektId"]
        end
      end
      
      personId = "%06d" % user.remote_id
      lonnsartNr = "%05d" % 8
      avdelingsNr = "%012d" % 5467
      element1Nr = "%012d" % 0
      element2Nr = "%012d" % 0
      element3Nr = "%012d" % 0
      element4Nr = "%012d" % 0
      element5Nr = "%012d" % 0
      dato = workday.created_at.strftime("%d%m%y")
      antall = "%010d" % (antallKalk.to_i*100).to_s
      belop = "%013d" % (antallKalk.to_i*satsKalk.to_i*100).to_s
      filler= "                              "
      end_of_line = "\r\n"
      #Skriver en linje til filen
    
      file_string = personId+lonnsartNr+avdelingsNr+prosjektNr+element1Nr+element2Nr+element3Nr+element4Nr+element5Nr+dato+antall+sats+belop+filler+end_of_line
      puts file_string.encoding
      file = Iconv.conv("iso8859-1", "UTF-8", file_string)
      IO.binwrite("/tmp/IT0001TRS.HLW", file, position)
      position += 166
    end
    end
    return true
  end


end
