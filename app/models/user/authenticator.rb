class User::Authenticator
  attr_accessor :user, :function, :email_subject
  include Authentication

  def initialize user, function, email_subject=nil
    @user = user
    @user.class.module_eval { attr_accessor "#{function}_token" }
    @function = function
    @email_subject = email_subject
  end

  def perform
    set
    send_email(email_subject) if email_subject
  end

end
