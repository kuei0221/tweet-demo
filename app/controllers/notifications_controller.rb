class NotificationsController < ApplicationController

  def index
    @notifications = current_user.notifications.includes(:micropost, :user).limit(5).desc_time_order if login?
    respond_to do |format|
      format.js
    end
  end

  def update
    user = User.find_by(id: current_user.id)
    if user
      user.notifications.unread.read
    end
  end
  
  def show
    user = User.find_by(id: current_user.id)
    loader = params[:loader].to_i
    loading_notifications = 3
    loaded_notifications = 5 + (loader-1) * loading_notifications
    if user
      @more_notifications = user.notifications.desc_time_order.offset(loaded_notifications).limit(loading_notifications)
    end
    respond_to do |format|
      format.js
    end
  end

end
