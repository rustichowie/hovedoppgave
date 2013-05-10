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
class Record < ActiveRecord::Base
  
  establish_connection "hlonn_database"
  
  def write_record(workdays)

    position = 0

    query = "select * FROM Program" #henter ut alle
    tst = connection.select_all(query) #select_all is important!
    tst.each do |result| #Fyller et array med relevant info, senere skal det ikke trenges å lage nytt array, men å hente ut akkurat det man vil ha rett fra spørringen
      ids.push(result.fetch('somthing somthing'))
    end
    
    #get lonnsartnr
    #get avdelingsnr
    #get prosjektnr
    #get element1-5
    #get sats

    workdays.each do |workday|

      personId = "%06d" % User.find(workday.user_id).remote_id
      lonnsartNr = "%05d" % 8
      avdelingsNr = "%012d" % 5467
      prosjektNr = "%012d" % 66
      element1Nr = "%012d" % 1
      element2Nr = "%012d" % 2
      element3Nr = "%012d" % 3
      element4Nr = "%012d" % 4
      element5Nr = "%012d" % 5
      dato = workday.created_at.strftime("%d%m%y")
      antall = ("%08d" % workday.get_workhour_sum(workday.date, workday.id))+"00"
      sats = "0000015500"
      belop = "0000002244500"
      filler= "000000000000000000000000000000"
      cr = "\f"
      lf = "\n"

      IO.binwrite("/tmp/ITxxxxTRS.HLW", personId+lonnsartNr+avdelingsNr+prosjektNr+element1Nr+element2Nr+element3Nr+element4Nr+element5Nr+dato+antall+sats+belop+filler+cr+lf, position)
      position += 166
    end
    return true
  end


end
