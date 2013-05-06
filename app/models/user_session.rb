class UserSession < Authlogic::Session::Base 
  # attr_accessible :title, :body
  
  #Fra Authlogic gem.
  def to_key
    new_record? ? nil : [ self.send(self.class.primary_key) ]
  end
  def persisted?
    false
  end
end
