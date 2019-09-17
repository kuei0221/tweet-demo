class RelationshipsController < ApplicationController

  before_action :is_login?
  before_action :find_user, only: [:create, :destroy]

  def index
    @relationship = params[:relationship]
    @title = @relationship.capitalize
    @current_user = User.with_attached_avatar.includes(@relationship).find(params[:id])
    @users = @current_user.send(@relationship).with_attached_avatar.paginate(page: params[:page])
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
