module SessionsHelper
  def current_user
    @current_user = User.find_by_session_token(session[:session_token])
  end

  def log_in(user)
    user.reset_session_token!
    session[:session_token] = user.session_token
  end

  def log_out!
    current_user.reset_session_token! if current_user
    session[:session_token] = nil
  end

  def logged_in?
    !!current_user
  end

  def authenticate
    redirect_to new_session_url unless logged_in?
  end

  def prevent_creation_when_logged_in
    redirect_to root_url if logged_in?
  end
end
