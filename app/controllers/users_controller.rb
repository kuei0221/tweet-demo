class UsersController < ApplicationController

  before_action :find_user_with_avatar, only: [ :edit, :update]
  before_action :find_user_with_avatar_and_microposts, only: :show
  before_action :is_login?, only: [:show, :edit, :update, :destroy]
  before_action :check_user, only: [:edit, :update]
  before_action :check_activated, only: [:show, :edit, :update, :destroy]
  before_action :check_admin, only: :destroy
  
  def index
    @users = User.activated.with_attached_avatar.includes(:microposts).paginate(page: params[:page])
    @user = User.with_attached_avatar.includes(:microposts, :following).find(current_user.id)
  end

  def show
    @microposts = @user.microposts.with_attached_picture.paginate(page: params[:page], per_page: 15)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_email(:account_activation)
      flash[:success] = "Sign up success! Please Check your email for activation"
      redirect_to root_url
    else
      flash.now[:danger] = "Sign up failed!"
      render :new
    end
  end
  
  def edit
  end

  def update
    if params[:user][:password_confirmation].present? && params[:user][:password].empty?
      @user.errors.add(:base, "Should not leave the confirmation with password.")
      flash.now[:danger] = "Update fail"
      render :edit
    elsif @user.update(user_params)
      flash[:success] = "Update success"
      redirect_to @user
    else
      flash.now[:danger] = "Update fail"
      render :edit
    end
  end

  def destroy
    @user = User.find_by(id: params[:id])
    @user.destroy
    flash[:success] = "User deleted."
    redirect_to users_path
  end

  def following
    @title = "Following"
    @user = User.with_attached_avatar.includes(:microposts, :following).find(params[:id])
    @users = @user.following.with_attached_avatar.includes(:microposts).paginate(page: params[:page])
    render "show_follow"
  end

  def followers
    @title = "Followers"
    @user = User.with_attached_avatar.includes(:microposts, :following).find(params[:id])
    @users = @user.followers.with_attached_avatar.includes(:microposts).paginate(page: params[:page])
    render "show_follow"
  end


  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :avatar)
  end

  def find_user_with_avatar
    @user = User.with_attached_avatar.find_by(id: params[:id])
  end

  def find_user_with_avatar_and_microposts
    @user = User.with_attached_avatar.includes(:microposts).find_by(id: params[:id])
  end

  def check_user
    @user = User.find_by(id: params[:id])
    unless current_user?(@user)
      flash[:danger] = "You do not have enough authorization !"
      redirect_to root_url 
    end
  end  

  def check_admin
    redirect_to root_url unless current_user.admin?
  end
  
  def check_activated
    redirect_to root_url unless current_user.activated?
  end

end
