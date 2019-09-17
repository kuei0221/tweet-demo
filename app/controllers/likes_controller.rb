class LikesController < ApplicationController

  before_action :find_micropost

  def create
    if current_user.liked? @micropost
      flash[:danger] = "You have Liked this post."
    else
      current_user.like @micropost
    end
    redirect_back fallback_location: root_path
  end
  
  def destroy
    if current_user.liked? @micropost
      current_user.unlike @micropost
    else
      flash[:danger] = "You cannot unlike before like."
    end
    redirect_back fallback_location: root_path
  end

  private
  def find_micropost
    @micropost = Micropost.find(params[:id])
  end
end
