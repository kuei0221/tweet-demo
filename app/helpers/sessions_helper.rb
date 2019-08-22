module SessionsHelper

  def login_as(user)
    session[:user_id] = user.id
  end

  def login?
    !session[:user_id].nil?
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if login?
  end

  def logout
    if login?
      session.delete(:user_id)
      @current_user = nil
    end
  end
  
end
