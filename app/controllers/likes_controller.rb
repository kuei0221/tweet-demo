class LikesController < ApplicationController

  before_action :find_micropost
  
  def update
    if params[:like] == "true" && !current_user.liked?(@micropost)
      current_user.like @micropost
    elsif params[:like] == "false" && current_user.liked?(@micropost)
      current_user.unlike @micropost
    else
      flash[:danger] = "Problem occurred when #{pressing_that_button}"
    end
    redirect_back fallback_location: root_path
  end
  
  private
  def find_micropost
    @micropost = Micropost.find(params[:id])
  end

  def pressing_that_button
    params[:like] == "true" ? "liking" : "unliking"
  end
end
