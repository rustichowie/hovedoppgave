authorization do
  
  role :guest do
    has_permission_on [:user_sessions], :to => [:read, :create]

  end
  role :ansatt do
    includes :guest
    has_permission_on [:user_sessions], :to => [:administrate] 
    has_permission_on [:users], :to => [:show, :manage] do
      if_attribute :id => is { user.id }
    end
  end
  role :formann do
    includes :ansatt
    has_permission_on [:cards], :to => [:read]
    has_permission_on [:workdays], :to => [:read, :manage]
  end
  role :administrator do
    includes :formann
    has_permission_on [:cards], :to => [:administrate]
    has_permission_on [:groups], :to => [:administrate]
    has_permission_on [:users], :to => [:administrate]
    has_permission_on [:logs], :to => [:administrate]
  end
end

privileges do
    privilege :administrate, :includes => [:read, :manage, :delete]
    privilege :manage, :includes => [:create, :update, :approve_all]
    privilege :read, :includes => [:index, :show]
    privilege :create, :includes => :new
    privilege :update, :includes => :edit
    privilege :delete, :includes => :destroy
    privilege :approve_all, :includes => :approve_all
  end