class Micropost < ApplicationRecord
  belongs_to :user

  has_many :likes
  has_many :liked_users, through: :likes, source: :user

  has_one_attached :picture

  scope :feed, -> (user) { where("user_id IN (?) or user_id = ? ", user.following_ids, user.id) }
  
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: 140}

  def liked? user
    liked_users.include? user
  end

  # def liked user
  #   liked_users << user
  # end

  # def unliked user
  #   liked_users.delete user
  # end

end
