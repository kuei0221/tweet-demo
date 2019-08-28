class ApplicationController < ActionController::Base
  include SessionsHelper

  private
  def is_login?
    unless login?
      flash[:danger] = "Please Login first !"
      redirect_to login_path 
    end
  end

  
end
