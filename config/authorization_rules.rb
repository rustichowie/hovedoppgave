authorization do
  
  role :guest do
    has_permission_on [:user_sessions], :to => [:read, :create]
  end
  role :ansatt do
    includes :guest
    has_permission_on [:user_sessions], :to => [:read, :manage] 
    has_permission_on [:users], :to => [:index]
    has_permission_on [:users], :to => [:show, :manage] do
      if_attribute :id => is { user.id }
    end
  end
  role :formann do
    includes :ansatt
  end
  role :administrator do
    includes :formann
    has_permission_on [:users], :to => [:read, :manage]
  end
end

privileges do
    privilege :manage, :includes => [:create, :read, :update, :delete]
    privilege :read, :includes => [:index, :show]
    privilege :create, :includes => :new
    privilege :update, :includes => :edit
    privilege :delete, :includes => :destroy
  end