class Relationship < ApplicationRecord
  belongs_to :follower, class_name: "User", counter_cache: :following_count, touch: true
  belongs_to :followed, class_name: "User", counter_cache: :followers_count, touch: true
  validates :followed_id, presence: true
  validates :follower_id, presence: true
end
