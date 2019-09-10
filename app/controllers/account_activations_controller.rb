class AccountActivationsController < ApplicationController
  
  def edit
    user = User.unscoped.find_by(email: params[:email], activated: false)
    if user && User::Authenticator.authenticate?(user, :activated, params[:id])
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
