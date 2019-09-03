class AccountActivationsController < ApplicationController
  
  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticate?(:activated, params[:id])
      user.activate
      login_as user
      flash[:success] = "Account Activate Success!"
      redirect_to user
    else
      flash[:danger] = "Invalid token or email"
      redirect_to root_url
    end
  end
end
