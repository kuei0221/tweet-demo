module LoginHelper
  def is_logged_in?
    !session[:user_id].nil?
  end


  def is_rememberred?(user)
    !cookies[:remember_token].nil? && 
    !user.remember_digest.nil? && 
    user.authenticate?(cookies[:remember_token])
  end
end