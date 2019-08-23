class UsersController < ApplicationController

  before_action :find_user, only: [:show, :edit, :update, :correct_user?]
  before_action :is_login?, only: [:show, :edit, :update]
  before_action :correct_user?, only: [:edit, :update]
  
  def index
    @users = User.take(20)
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
    if @user.update(user_params)
      flash[:success] = "Update success"
      redirect_to @user
    else
      flash.now[:danger] = "Update fail"
      render :edit
    end
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


end
