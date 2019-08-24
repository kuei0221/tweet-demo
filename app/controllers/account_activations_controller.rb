class AccountActivationsController < ApplicationController
  def edit
    #call this through the link in activation email
    #the link contain token(id) and email(email)
    #use email to find the user
    #check the token and digest whether is corret
    # if is, activate it. Then auto login, redirect to user's page
    # else back to signup
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
