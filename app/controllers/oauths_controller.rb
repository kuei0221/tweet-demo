require "rest-client"

class OauthsController < ApplicationController
  before_action :already_login?

  def create
    #first check response from provider, checking of provider should be done in logger
    #then check user with this order - 1. Have identity 2. Have same email 3. Create new User

    @provider = oauths_params[:provider]
    begin
      @res = OauthLogger.call @provider, oauths_params[:token]
    rescue ArgumentError => e
      puts e.message
    end
    @res.present? || render_invalid && return
    @user = find_identity_user || find_confirmed_email_user || create_new_identity_user || render_invalid && return
    login_as @user
    flash[:success] = "#{current_user.name}, Welcome!"
    render js: "window.location = '#{root_path}'"

  end

  private

  def oauths_params
    params.permit(:provider, :token)
  end

  def render_invalid
    flash[:danger] = "Login fail with #{@provider}"
    render js: "window.location = '#{login_path}' "
  end

  def find_identity_user
    identity = Identity.find_by(uid: @res[:uid], provider: @provider)
    return_object_and_message_if_true(identity, "You have connected with #{@provider.capitalize} already.", object_attribute: :user )
  end

  def find_confirmed_email_user
    user = User.find_by(email: @res[:email])
    user.identities.create(provider: @provider, uid: @res[:uid]) if user.present?
    return_object_and_message_if_true(user, "This email has already been sign up, will generate connection with it")
  end

  def create_new_identity_user
    user = Identity.create_user_with_identity @res, @provider
    return_object_and_message_if_true(user, "Sign in as a new user with #{@provider.capitalize}.", filter: :valid?)
  end

  def return_object_and_message_if_true(object, message, option={})
    filter = option.fetch(:filter, :present?)
    object_attribute = option.fetch(:object_attribute, :itself)

    if object.send filter
      flash[:notice] = message
      return object.send object_attribute
    end

  end


end