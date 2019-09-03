class User < ApplicationRecord

  has_many :microposts, dependent: :destroy
  has_many :active_relationships, class_name: "Relationship", 
                                  foreign_key: "follower_id", 
                                  dependent: :destroy
  has_many :passive_relationships, class_name: "Relationship",
                                   foreign_key: "followed_id",
                                   dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  has_one_attached :avatar
  
  attr_accessor :remember_token, :activated_token, :reset_token

  scope :activated, -> { where(activated: true)}

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
                       length: { minimum: 8, maximum: 51 },
                       allow_nil: true
  def remember
    remember_token = User.new_token
    update(remember_digest: User.digest(remember_token))
  end

  def forget
    update(remember_digest: nil)
  end

  def activate
    update(activated: true, activated_at: Time.zone.now)
  end

  def set_reset
    self.reset_token = User.new_token
    self.update(reset_digest: User.digest(reset_token))
  end

  def send_email subject
    UserMailer.send(subject, self).deliver_now if UserMailer.respond_to?(subject)
  end 
  
  def authenticate?(token_type, token)
    digest = self.send("#{token_type}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def feed
    following_ids = "SELECT followed_id FROM relationships
                     WHERE  follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids})
                     OR user_id = :user_id ", user_id: id)
  end

  def follow(other_user)
    following << other_user
  end

  def unfollow(other_user)
    following.delete(other_user)
  end

  def follow?(other_user)
    following.include?(other_user)
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
