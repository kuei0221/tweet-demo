class Comment < Micropost
  belongs_to :post, counter_cache: :comments_count, touch: true 
  default_scope -> { order(created_at: :asc) }
  validates :post_id, presence: true
  # delegate :id, to: :post, prefix: true
  delegate :comments_count, to: :post, prefix: true
end