class User < ApplicationRecord

  has_many :microposts, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :active_relationships, class_name: "Relationship", 
                                  foreign_key: "follower_id", 
                                  dependent: :destroy
  has_many :passive_relationships, class_name: "Relationship",
                                   foreign_key: "followed_id",
                                   dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  has_many :likes
  has_many :liked_posts, through: :likes, source: :micropost
  
  has_one_attached :avatar
  has_secure_password
  default_scope -> { where(activated: true) }
  before_save :downcase_email

  validates :email, uniqueness: { case_sensitive:false }
  validates :password, presence: true,
                       length: { minimum: 8, maximum: 51 },
                       allow_nil: true
  
  def activate
    update(activated: true, activated_at: Time.zone.now)
  end

  def feed
    Post.feed(self).with_attached_picture
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

  def like micropost
    micropost.liked_users << self
  end

  def unlike micropost
    micropost.liked_users.delete self
  end

  def liked? micropost
    micropost.liked_users.include? self
  end
  
  private
  def downcase_email
    self.email = email.downcase
  end

end
