class UsersController < ApplicationController

  before_action :find_user_with_avatar, only: [ :edit, :update]
  before_action :is_login?, only: [:show, :edit, :update, :destroy]
  before_action :check_user, only: [:edit, :update]
  
  def index
    @users_collection = User.with_attached_avatar
    @pagy, @users = pagy(@users_collection)
    @current_user = User.with_attached_avatar.includes(:following).find(current_user.id) if login?
  end
  
  def show
    @current_user = User.with_attached_avatar.includes(:following).find(current_user.id) if login?
    @user = User.with_attached_avatar.find(params[:id])
    @posts_collection = @user.posts.with_attached_picture.includes(:liked_users, :sharing)
    @pagy, @posts = pagy(@posts_collection)
    @comment = @current_user.comment
    @share = @current_user.share
  end

  def new
    @register = UserRegisterForm.new
  end
  
  def create
    @register = UserRegisterForm.new(user_params)
    if @register.save
      User::Authenticator.new(@register.user, :activated).perform
      flash[:success] = "Sign up success! Please Check your email for activation"
      redirect_to root_url
    else
      flash.now[:danger] = "Sign up failed!"
      render :new
    end
  end
  
  def edit
    @updater = UserUpdateForm.new(@user.attributes.slice("name", "email", "avatar"), @user)
  end

  def update
    @updater = UserUpdateForm.new(user_params, @user)
    if @updater.update
      flash[:success] = "Update success"
      redirect_to @user
    else
      flash.now[:danger] = "Update fail"
      render :edit
    end
  end

  def destroy
    check_admin
    @user = User.find(params[:id])
    @user.destroy
    flash[:success] = "User deleted."
    redirect_to users_path
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :avatar)
  end

  def find_user_with_avatar
    @user = User.with_attached_avatar.find(params[:id])
  end

  def check_user
    @user = User.find(params[:id])
    unless current_user?(@user)
      flash[:danger] = "You do not have enough authorization !"
      redirect_to root_url 
    end
  end  

  def check_admin
    redirect_to root_url unless current_user.admin?
  end
  
end
