class Like < ApplicationRecord
  belongs_to :micropost, counter_cache: :likes_count, touch: true
  belongs_to :user
  validates :micropost_id, presence: true
  validates :user_id, presence: true
  # after_save :notify_pusher

  #only active when post be liked, ignore unlike
  def notify_pusher
    Pusher["user-#{user.id}"].trigger("event", {"event": "<a href='/posts/#{micropost.id}' class='dropdown-item'>#{user.name} likes your post</a>"})
    Notification.create(user: micropost.user, micropost: micropost, action: "like", feeder: user.name)
  end
end
