module SessionsHelper

  def login_as user
    session[:user_id] = user.id
  end

  def login?
    !current_user.nil?
  end

  def current_user
    if session[:user_id]
      @current_user ||= User.find session[:user_id]
    elsif cookies.signed[:user_id]
      user = User.find cookies.signed[:user_id]
      if user && User.Authenticator.authenticate?(user, :remember, cookies[:remember_token])
        login_as user
        @current_user = user
      end
    end
  end

  # def current_user_with_following
  #   if current_user
  #     @current_user_with_following ||= User.includes(:following).find(current_user.id)
  #   end
  # end

  def current_user? user
    current_user == user
  end


  def logout
    forget_as current_user
    session.delete :user_id
    @current_user = nil
  end

  def remember_as user
    User::Authenticator.new(user, :remember).perform
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def forget_as user
    User::Authenticator.new(user, :remember).clean
    cookies.delete :user_id
    cookies.delete :remember_token
  end

end
