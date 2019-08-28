class UsersController < ApplicationController

  before_action :find_user, only: [:show, :edit, :update, :destroy]
  before_action :is_login?, only: [:show, :edit, :update, :destroy]
  before_action :correct_user?, only: [:edit, :update]
  before_action :activated_user?, only: [:show, :edit, :update, :destroy]
  before_action :admin_user?, only: :destroy
  
  def index
    @users = User.where(activated: true).includes(:microposts).paginate(page: params[:page])
  end

  def show
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      UserMailer.account_activation(@user).deliver_now
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
    #might have password confirmation problem/ try update_attribute
    if !params[:user][:password_confirmation].empty? && params[:user][:password].empty?
      @user.errors.add(:base, "Should not leave the confirmation with password.")
      flash.now[:danger] = "Update fail"
      render :edit
    elsif @user.update_attributes(user_params)
      flash[:success] = "Update success"
      redirect_to @user
    else
      flash.now[:danger] = "Update fail"
      render :edit
    end
  end

  def destroy
    @user.destroy
    flash[:success] = "User deleted."
    redirect_to users_path
  end


  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def find_user
    @user = User.find_by(id: params[:id])
  end

  def correct_user?
    @user = User.find_by(id: params[:id])
    unless current_user == @user
      flash[:danger] = "You do not have enough authorization !"
      redirect_to root_url 
    end
  end  

  def admin_user?
    redirect_to root_url unless current_user.admin?
  end
  
  def activated_user?
    redirect_to root_url unless current_user.activated?
  end


end
