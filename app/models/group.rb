# == Schema Information
#
# Table name: groups
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Group < ActiveRecord::Base
  attr_accessible :name
  has_many :users
  
  after_create do
  create_log
  end
  after_destroy do
  delete_log
  end
  
  def delete_log
    unless UserSession.find == nil
      Log.create(user_id: UserSession.find.user.id, message: "#{UserSession.find.user.name} har slettet avdelingen: #{self.name}", logtype_id: 3)
    end
  end
  
  def create_log
    unless UserSession.find == nil
      Log.create(user_id: UserSession.find.user.id, message: "#{UserSession.find.user.name} har opprettet en ny avdeling med navn: #{self.name}", logtype_id: 2)
    end
  end
  def database
    #passord må fylles inn etter push
    file = File.new("db_pwd", "r")
    pwd = file.read.chomp
    file.close
    return client = TinyTds::Client.new(:username => 'timereg', :password => "#{pwd}", :host => '192.168.44.4', :database => 'HLonn0004')
  end
  def import_groups
    remote = []
    result = []
    import_array = []
    #Starter connection mot database
    client = database()
    
    #Henter alle personer
      result = client.execute("SELECT * FROM Prosjekter")
      
      #lagrer nødvendig data til array
      result.each do |res|
        name = Iconv.conv("UTF-8", "iso8859-1", res["NAVN"])
        name = UnicodeUtils.downcase(name.downcase)
        name = name.split(" ").each{|word| word.capitalize!}.join(" ")
  
        r = {"id" =>  res["ProsjekterID"], "navn" => "#{name}"}
        remote.push(r)
      end
      groups = Group.all
      #Går gjennom alle brukerne for hver bruker hos HLonn0004, og sjekker om de allerede er importert, hvis ikke importeres de.
      remote.each do |rem|
        exist = false #bool som holder på verdien om de eksisterer eller ikke
        groups.each do |group|
          unless group.remote_id == nil
            if rem["id"] == group.remote_id
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
