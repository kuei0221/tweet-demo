class UsersController < ApplicationController
  
  def index
    @users = User.take(20)
  end

  def show
    @user = User.find_by(id: params[:id])
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
    @user = User.find_by(id: params[:id])
  end

  def update
    @user = User.find_by(id: params[:id])
    if @user.update(user_params)
      flash[:success] = "Update success"
      redirect_to @user
    else
      flash[:danger] = "Update fail"
      render :edit
    end
  end


  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end


end
