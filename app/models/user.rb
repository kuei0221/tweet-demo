class User < ApplicationRecord
  before_save :downcase_email

  attr_accessor :remember_token

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

  def authenticate?(token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(token)
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


end
