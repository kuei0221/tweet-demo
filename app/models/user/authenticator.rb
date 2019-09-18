class User::Authenticator
  attr_accessor :user, :function
  include Authentication

  def initialize user, function
    @user = user
    @user.class.module_eval { attr_accessor "#{function}_token" }
    @function = function
  end

  def perform
    
    set
    case function
    when :activated
      send_email(:account_activation)
    when :reset
      send_email(:password_reset)
    end

  end

end
