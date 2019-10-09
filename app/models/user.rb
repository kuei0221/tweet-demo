class User < ApplicationRecord

  #association with post
  has_many :microposts, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :identities, dependent: :destroy
  #association with follow
  has_many :active_relationships, class_name: "Relationship", 
                                  foreign_key: "follower_id", 
                                  dependent: :destroy
  has_many :passive_relationships, class_name: "Relationship",
                                   foreign_key: "followed_id",
                                   dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  #association with like
  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :micropost #not used now
  
  #user info setting
  has_one_attached :avatar
  has_secure_password

  #scope
  default_scope -> { where activated: true }
  scope :inactivated, -> { unscoped.where activated: false }
  scope :random, -> (nums=1) { unscoped.order("RANDOM()").limit(nums) }
  
  #validate
  validates :email, uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 8, maximum: 51 }, allow_nil: true
  
  #callback
  before_save :downcase_email

  def activate
    update(activated: true, activated_at: Time.zone.now)
  end

  def feed
    Post.feed(self).includes(
      :liked_users, #to determine like/unlike
      sharing: {user: [avatar_attachment: :blob], picture_attachment: :blob}, #show shared post if share
      user:{avatar_attachment: :blob}, #user info, avatar
      picture_attachment: :blob
      ) #post picture
  end

  def follow(other_user)
    following << other_user
  end

  def unfollow(other_user)
    following.destroy other_user
  end

  def follow?(other_user)
    following.include? other_user
  end

  def like(micropost)
    micropost.liked_users << self
  end

  def unlike(micropost)
    micropost.liked_users.destroy self
  end

  def liked?(micropost)
    micropost.liked_users.include? self
  end

  def share(post=nil, content=nil)
    @share = self.posts.build(sharing: post, content: content)
  end
  
  def share!(post=nil, content=nil)
    @share = self.posts.create(sharing: post, content: content)
  end

  def comment(post=nil, content=nil)
    @comment = self.comments.build(post: post, content: content)
  end
  
  def comment!(post=nil, content=nil)
    @comment = self.comments.create(post: post, content: content)
  end

  private
  def downcase_email
    self.email = email.downcase
  end

end
