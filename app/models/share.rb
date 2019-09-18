class Share < ApplicationRecord
  belongs_to :sharing, class_name: "Post", counter_cache: :shares_count, touch: true
  belongs_to :shared, class_name: "Post"
  validates :sharing_id, presence: true
  validates :shared_id, presence: true
end
