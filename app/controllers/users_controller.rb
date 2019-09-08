class UsersController < ApplicationController

  before_action :find_user_with_avatar, only: [ :edit, :update]
  before_action :is_login?, only: [:show, :edit, :update, :destroy]
  before_action :check_user, only: [:edit, :update]
  before_action :check_activated, only: [:show, :edit, :update, :destroy]
  
  def index
    @users = User.activated.with_attached_avatar.paginate(page: params[:page]) 
    @user = User.with_attached_avatar.includes(:following).find(current_user.id) if login?
  end

  def show
    @user = User.with_attached_avatar.includes(:microposts).find(params[:id])
    @microposts = @user.microposts.with_attached_picture.paginate(page: params[:page], per_page: 15)
  end

  def new
    @register = UserRegisterForm.new
  end
  
  def create
    @register = UserRegisterForm.new(user_params)
    if @register.save
      User::Authenticator.new(@register.user, :activated, :account_activation).perform
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
  
  def check_activated
    redirect_to root_url unless current_user.activated?
  end

end
