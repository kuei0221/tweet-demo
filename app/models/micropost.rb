class Micropost < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc)}# very big #deleted at :time 
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: 140}
end
