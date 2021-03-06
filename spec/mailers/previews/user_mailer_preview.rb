# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  def account_activation
    user = User.last
    user.activated_token = User.new_token
    UserMailer.account_activation(user)
  end

  def password_reset
    user = User.first
    user.set_reset
    UserMailer.password_reset(user)
  end
end
