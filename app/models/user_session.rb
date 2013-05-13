class UserSession < Authlogic::Session::Base 
  # attr_accessible :title, :body
  
  find_by_login_method :find_by_username_or_mobile
  #Fra Authlogic gem.
  def to_key
    new_record? ? nil : [ self.send(self.class.primary_key) ]
  end
  def persisted?
    false
  end
end
