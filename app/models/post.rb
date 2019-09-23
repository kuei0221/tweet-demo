class Post < Micropost
  has_many :comments

  has_one :sharing_relationship, class_name: "Share", foreign_key: "shared_id"
  has_one :sharing, through: :sharing_relationship, source: :sharing

  has_many :shared_relationship, class_name: "Share", foreign_key: "sharing_id"
  has_many :shared, through: :shared_relationship, source: :shared

  default_scope -> { order(created_at: :desc)}
  scope :feed, -> (user) { where("user_id IN (?) or user_id = ? ", user.following_ids, user.id) }

end
