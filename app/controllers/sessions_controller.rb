class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        login_as user
        params[:session][:remember_me] == "1" ? remember_as(user) : forget_as(user)
        flash[:success] = "login success"
        flash[:notice] = "#{current_user.name}, Welcome!"
        redirect_to root_url
      else 
        flash.now[:notice] = "Please activate you account first"
        redirect_to root_url
      end
    else
      flash.now[:danger] = "Login fail"
      render :new
    end
  end


  def destroy
    if login?
      logout
      flash[:success] = "Logout success"
    end
    redirect_to root_url
  end

end
