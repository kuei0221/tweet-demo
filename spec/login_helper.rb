module LoginHelper
  def is_logged_in?
    !session[:user_id].nil?
  end

  def is_rememberred?(user)
    cookies[:remember_token].present? &&
    user.remember_digest.present? && 
    User::Authenticator.authenticate?(user, :remember, cookies[:remember_token])
  end

  def create_UserRegisterForm(user)
    UserRegisterForm.new(
      name: user.name,
      email: user.email,
      password: user.password,
      password_confirmation: user.password_confirmation
    )
  end

  def create_UserUpdateForm(params={}, user)
    UserUpdateForm.new( params, user )
  end
end