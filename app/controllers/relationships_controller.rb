class RelationshipsController < ApplicationController

  before_action :is_login?
  before_action :find_user, only: [:create, :destroy]

  def index
    @relationship = params[:relationship]
    @title = @relationship.capitalize
    @user = User.with_attached_avatar.includes(@relationship).find(params[:id])
    @users_collection = @user.send(@relationship).with_attached_avatar
    @pagy, @users = pagy(@users_collection)
  end

  def create
    unless current_user.follow? @user
      current_user.follow(@user)
    end
    redirect_to @user
  end

  def destroy
    if current_user.follow? @user
      current_user.unfollow(@user)
    end
    redirect_to @user
  end

  private
  def find_user
    @user = User.find(params[:followed_id])
  end

end
