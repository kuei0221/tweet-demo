class LikesController < ApplicationController

  before_action :find_micropost
  
  def update

    respond_to do |format|

      if check_like == "like"
        current_user.like @micropost
        @notification = Notification.create(user: @micropost.user, micropost: @micropost, action: "like", feeder: current_user.name)
        Pusher["user-#{@micropost.user.id}"].trigger("event", { "event": "should show message"})
        format.js
      elsif check_like == "unlike"
        current_user.unlike @micropost
        format.js
      else
        flash[:danger] = "Problem occurred when #{params[:like_action]}"
      end

      format.html { redirect_back fallback_location: root_path }
    end

  end
  
  private
  def find_micropost
    @micropost = Micropost.find(params[:id])
  end

  def is_post_liked?
    current_user.liked? @micropost if current_user.present?
  end

  def check_like

    if params[:like_action].present?
      if params[:like_action] == "like" && !is_post_liked?
        return "like"
      elsif params[:like_action] == "unlike" && is_post_liked?
        return "unlike"
      else
        return false
      end
    end

  end
end
