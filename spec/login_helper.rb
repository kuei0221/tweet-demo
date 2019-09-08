module LoginHelper
  def is_logged_in?
    !session[:user_id].nil?
  end


  def is_rememberred?(user)
    cookies[:remember_token].present? &&
    user.remember_digest.present? && 
    User::Authenticator.authenticate?(user, :remember, cookies[:remember_token])
  end
end