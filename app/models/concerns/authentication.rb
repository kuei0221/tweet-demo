module Authentication
  
  # Assume this module is included in a class holding attribute :user, :function, :subject_email
  extend ActiveSupport::Concern

  class_methods do

    def new_token
      SecureRandom.urlsafe_base64
    end
    
    def digest(token)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
      BCrypt::Password.create(token, cost: cost)
    end

    def authenticate?(object, function, token)
      digest = object.send("#{function}_digest")
      return false if digest.nil?
      BCrypt::Password.new(digest).is_password?(token)
    end
 
  end

  def set
    user.send("#{function}_token=", self.class.new_token)
    user.update("#{function}_digest": self.class.digest(user.send("#{function}_token")))
  end

  def clean
    user.update("#{function}_digest": nil)
  end

  def send_email(subject)
    UserMailer.send(subject, user).deliver_now if UserMailer.respond_to?(subject)
  end

end