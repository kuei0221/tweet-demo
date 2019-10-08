class ApplicationController < ActionController::Base
  include SessionsHelper

  private
  def is_login?
    unless login?
      flash[:danger] = "Please Login first !"
      redirect_to login_path 
    end
  end

  def already_login?
    if login?
      flash[:notice] = "You have already login!"
      redirect_to root_path
    end
  end

  
end
