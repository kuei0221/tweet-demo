module SessionsHelper

  def login_as(user)
    session[:user_id] = user.id
  end

  def login?
    !current_user.nil?
  end

  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticate?(:remember, cookies[:remember_token])
        login_as user
        @current_user = user
      end
    end
  end

  def current_user?(user)
    current_user == user
  end


  def logout
    forget_as(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  def remember_as(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def forget_as(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

end
