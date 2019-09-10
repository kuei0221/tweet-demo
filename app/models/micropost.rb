class Micropost < ApplicationRecord
  belongs_to :user

  has_many :likes
  has_many :likers, through: :likes, source: :user

  has_one_attached :picture

  default_scope -> { order(created_at: :desc)}# very big #deleted at :time 
  scope :feed, -> (user) { where("user_id IN (?) or user_id = ? ", user.following_ids, user.id) }
  
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: 140}

  def liked? user
    likers.include? user
  end
end
