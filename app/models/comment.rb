class Comment < Micropost
  belongs_to :post, counter_cache: :comments_count
  default_scope -> { order(created_at: :asc) }

  validates :post_id, presence: true

end