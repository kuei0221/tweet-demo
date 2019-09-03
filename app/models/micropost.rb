class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :picture
  default_scope -> { order(created_at: :desc)}# very big #deleted at :time 
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: 140}
end
