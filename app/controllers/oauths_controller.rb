require "rest-client"

class OauthsController < ApplicationController
  before_action :already_login?

  def create

    provider = oauths_params[:provider]
    token = oauths_params[:token]
    logger = OauthLogger.new(provider)
    @res = logger.perform(token)
    # check respose and start login process
    # have identity - find user and login * identity should only create with user
    # dont have identity but have user with same email - connect identity and user with email and then login
    # dont have indentity and dont have user either - connect and create
    
    if @res.present?
      @identity = Identity.find_by(uid: @res[:uid], provider: provider)
      
      if @identity.present?
        @user = @identity.user
        flash[:notice] = "You have connected with #{provider.capitalize} already."
      else
        @user = User.find_by(email: @res[:email])
        if @user.present?
          flash[:notice] = "This email has already been sign up, will generate connection with it"
        else
          @user = Identity.create_user_with_identity @res, provider
          flash[:notice] = "Sign in as a new user with #{provider.capitalize}."
        end
      end

      login_as @user if @user
      flash[:success] = "#{current_user.name}, Welcome!"
    else
      flash[:danger] = "Login fail"
    end
    # if using render instead, the returned code will been shown in the url
    render js: "window.location =  '#{root_path}'"
    
  end

  private
  def oauths_params
    params.permit(:provider, :token)
  end

end