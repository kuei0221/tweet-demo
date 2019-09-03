class RelationshipsController < ApplicationController

  before_action :is_login?

  def create
    @user = User.find(params[:followed_id])
    current_user.follow(@user)
    redirect_to @user
  end

  def destroy
    @user = User.find(params[:followed_id])
    current_user.unfollow(@user)
    redirect_to @user
  end

end
