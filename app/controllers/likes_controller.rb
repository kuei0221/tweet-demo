class LikesController < ApplicationController

  def create
    #get id of post and id of liked user, than increase like in post and add like_user_in in post(unique)
    Like.create(micropost_id: params[:id], user_id: current_user.id)
    redirect_back fallback_location: root_path
  end

  def destroy
    Like.find_by(micropost_id: params[:id], user_id: current_user.id).destroy
    redirect_back fallback_location: root_path
  end
end
