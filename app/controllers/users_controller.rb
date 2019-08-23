class UsersController < ApplicationController

  before_action :find_user, only: [:show, :edit, :update, :destroy,:correct_user?]
  before_action :is_login?, only: [:show, :edit, :update, :destroy]
  before_action :correct_user?, only: [:edit, :update]
  before_action :admin_user?, only: :destroy
  
  def index
    @users = User.paginate(page: params[:page])
  end

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Sign up success!"
      redirect_to @user
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

  def is_login?
    unless login?
      flash[:danger] = "Please Login first !"
      redirect_to login_path 
    end
  end

  def correct_user?
    unless current_user == @user
      flash[:danger] = "You do not have enough authorization !"
      redirect_to root_url 
    end
  end

  def admin_user?
    redirect_to root_url unless current_user.admin?
  end


end
