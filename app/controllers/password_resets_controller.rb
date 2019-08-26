class PasswordResetsController < ApplicationController

  before_action :find_by_email, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]

  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user && @user.activated?
      @user.set_reset
      @user.sent_reset_email
      flash[:notice] = "Email has been sent"
      redirect_to login_path
    else
      flash.now[:danger] = "Invalid or incorrect email!"
      render :new
    end
  end

  def edit
  end

  def update
    if user_params[:password].empty?
      @user.errors.add(:password, "Password cannot be empty.")
      flash.now[:danger] = "Invalid password"
      render :edit
    elsif @user.update_attributes(user_params)
      login_as @user
      flash[:success] = "Password has been reset."
      redirect_to @user
    else
      flash.now[:danger] = "Reset failed"
      render :edit
    end
  end

  private

  def find_by_email
    @user = User.find_by(email: params[:email])
  end

  def valid_user
    unless @user && @user.activated? && @user.authenticate?(:reset, params[:id])
      flash[:danger] = "Invalid Link"
      redirect_to root_url
    end
  end

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
