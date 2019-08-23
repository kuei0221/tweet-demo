class SessionsController < ApplicationController

  def new
  end

  def create
    # byebug
    user = User.find_by(email: params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      #exist and correct password
      login_as user
      params[:session][:remember_me] == "1" ? remember_as(user) : forget_as(user)
      flash[:success] = "login success"
      flash[:notice] = "#{current_user.name}, Welcome!"
      redirect_to user
    else
      #not exist
      flash.now[:danger] = "Login fail"
      render :new
    end
  end

  def destroy
    # byebug
    if login?
      logout
      flash[:success] = "Logout success"
    end
    redirect_to root_url
  end

end
