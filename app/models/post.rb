class Post < Micropost
  has_many :comments
  default_scope -> { order(created_at: :desc)}
  scope :feed, -> (user) { where("user_id IN (?) or user_id = ? ", user.following_ids, user.id) }
end