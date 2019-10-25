require "rest-client"

class OauthsController < ApplicationController
  before_action :already_login?

  def create
    #first check response from provider, checking of provider should be done in logger
    #then check user with this order - 1. Have identity 2. Have same email 3. Create new User

    @provider = oauths_params[:provider]
    @user = nil
    begin
      @res = OauthLogger.call @provider, oauths_params[:token]
    rescue ArgumentError => e
      puts e.message
      @user = false
    end


    if @user.nil?
      @user = find_identity_user
      message = "You have connected with #{@provider.capitalize} already."
    end

    if @user.nil?
      @user = find_confirmed_email_user
      message = "This email has already been sign up, will generate connection with it"
    end

    if @user.nil?
      @user = create_new_identity_user
      message = "Sign in as a new user with #{@provider.capitalize}."
    end

    respond_to do |format|
      if @user.present?
        login_as @user
        flash[:notice] = message
        format.js { render js: "window.location = '#{root_path}'", status: :ok}
      else
        flash[:danger] = "Login fail with #{@provider}"
        format.js { render js: "window.location = '#{login_path}'", status: :bad_request}
      end
    end

  end

  private

  def oauths_params
    params.permit(:provider, :token)
  end

  def find_identity_user
    identity = Identity.find_by(uid: @res[:uid], provider: @provider)
    identity.user if identity
  end

  def find_confirmed_email_user
    user = User.find_by(email: @res[:email])
    if user.present?
      user.identities.create(provider: @provider, uid: @res[:uid])
      user
    end
  end

  def create_new_identity_user
    user = Identity.create_user_with_identity @res, @provider
    user if user.valid?
  end

end