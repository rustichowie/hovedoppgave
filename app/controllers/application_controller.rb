class ApplicationController < ActionController::Base
  #include Authentication
  
  protect_from_forgery
  

  #filter_parameter_logging :password
  helper :all
  
  helper_method :set_current_user, :current_user_session, :current_user 
  rescue_from ActiveRecord::RecordNotFound, :with => :render_404
  
  
  #rescue fra RecordNotFound, sender deg til side ikke funnet.
  def render_404
    render template: '/shared/record_not_found', layout: false, status: :not_found
  end
  before_filter { |c| Authorization.current_user = c.current_user }
  before_filter :set_language
  #private
  
  #Setter default språk til norsk
  def set_language
    I18n.locale = 'nb'
  end
  
  
  def set_current_user
    Authorization.current_user = current_user 
  end
  
    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end

    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.record
    end

    def require_user
      unless current_user
        store_location
        flash[:notice] = "You must be logged in to access this page"
        redirect_to login_url
        return false
      end
    end

    def require_no_user
      if current_user
        store_location
        flash[:notice] = "You must be logged out to access this page"
        redirect_to users_url # TODO: change this to the main page
        return false
      end
    end

    def store_location
      session[:return_to] = request.fullpath
    end

    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end
    
    def permission_denied
      if current_user
        render :template => 'shared/access_denied'
      else
        flash[:notice] = 'Access denied. Try to log in first.'
        redirect_to login_path
      end
    end    
end