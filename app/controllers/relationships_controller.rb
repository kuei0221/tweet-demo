class RelationshipsController < ApplicationController

  before_action :is_login?

  def index
    @relationship = params[:relationship]
    @title = @relationship.capitalize
    @current_user = User.with_attached_avatar.includes(@relationship).find(params[:id])
    @users = @current_user.send(@relationship).with_attached_avatar.paginate(page: params[:page])
  end

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
