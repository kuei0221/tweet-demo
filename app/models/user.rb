class User < ApplicationRecord
  attr_accessor :remember_token, :activated_token, :reset_token

  before_save :downcase_email
  before_create :create_account_activation



  validates :name, presence: true, 
                   length: { minimum: 6, maximum: 51}

                   validates :email, presence: true,
                   length: {maximum: 255},
                   uniqueness: {case_sensitive: false},
                   format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i }
                   
  has_secure_password
  validates :password, presence: true,
                       length: {minimum: 8, maximum: 51},
                       allow_nil: true
  
  def remember
    self.remember_token = User.new_token
    self.update_attribute(:remember_digest, User.digest(remember_token))
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  def set_reset
    self.reset_token = User.new_token
    self.update_attribute(:reset_digest, User.digest(reset_token))
  end

  def sent_reset_email
    UserMailer.password_reset(self).deliver_now
  end
  
  def authenticate?(token_type, token)
    digest = self.send("#{token_type}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end
  
  def self.new_token
    SecureRandom.urlsafe_base64
  end
  
  def self.digest(token)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(token, cost: cost)
  end
  
  private
  def downcase_email
    self.email = email.downcase
  end
  
  def create_account_activation
    self.activated_token = User.new_token
    self.activated_digest = User.digest(activated_token)
  end

end
