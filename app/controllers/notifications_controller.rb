class NotificationsController < ApplicationController

  # load notifications content
  def index
    loader = params["new"] == "true" ? 1 : 5
    @notifications = current_user.notifications.with_post_info.desc_time_order.limit(loader) if login?
    respond_to do |format|
      format.js
    end
  end

  #initial pusher connection
  def new
    respond_to do |format|
      if login? && current_user
        format.js
      else
        format.json { render json: {Error: "Please login first"}}
      end
    end
  end

  #Read notification
  def update
    user = User.find_by(id: current_user.id)
    user.notifications.unread.read if user.present?
  end
  
  #load more notification
  def show
    user = User.find_by(id: current_user.id)
    oldest_id = params[:oldest_id].to_i
    if user
      @more_notifications = user
      .notifications
      .with_post_info
      .load_history(oldest_id)
    end
    respond_to do |format|
      format.js
    end
  end
end
