class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :micropost

  has_one_attached :feeder_avatar

  validates_presence_of :user, :micropost, :action, :feeder

  scope :desc_time_order, -> { order(created_at: :desc) }
  scope :unread, -> { where(new: true) }
  scope :history, -> (id) { where("id < ?", id) }

  def message
    "#{feeder} has #{action} your post: #{micropost.content[0..25]}"
  end

  def self.read
    update_all(new: false, updated_at: Time.zone.now)
  end

  def self.load_history(oldest_id)
    history(oldest_id).desc_time_order.limit(3)
  end

  def self.with_post_info
    with_attached_feeder_avatar.includes(:micropost)
  end

end
